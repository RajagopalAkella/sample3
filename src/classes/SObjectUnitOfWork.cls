public class SObjectUnitOfWork
{
	private List<Schema.SObjectType> m_sObjectTypes = new List<Schema.SObjectType>();	
	private Map<String, List<SObject>> m_newListByType = new Map<String, List<SObject>>();	
	private Map<String, List<SObject>> m_dirtyListByType = new Map<String, List<SObject>>();	
	private Map<String, List<SObject>> m_deletedListByType = new Map<String, List<SObject>>();	
	private Map<String, Relationships> m_relationships = new Map<String, Relationships>();
	
	/**
	 * Constructs a new UnitOfWork to support work against the given object list
	 * @param sObjectList A list of objects given in dependency order (least dependent first)
	 */
	public SObjectUnitOfWork(List<Schema.SObjectType> sObjectTypes)
	{
		m_sObjectTypes = sObjectTypes.clone();
		for(Schema.SObjectType sObjectType : m_sObjectTypes)
		{
			m_newListByType.put(sObjectType.getDescribe().getName(), new List<SObject>());
			m_dirtyListByType.put(sObjectType.getDescribe().getName(), new List<SObject>());
			m_deletedListByType.put(sObjectType.getDescribe().getName(), new List<SObject>());
			m_relationships.put(sObjectType.getDescribe().getName(), new Relationships());	
		}
	}
	
	/**
	 * Register a newly created SObject instance to be inserted when commitWork is called
	 *
	 * @param record A newly created SObject instance to be inserted during commitWork
	 **/
	public void registerNew(SObject record)
	{
		registerNew(record, null, null);
	}

	/**
	 * Register a newly created SObject instance to be inserted when commitWork is called, 
	 *   you may also provide a reference to the parent record instance (should also be registered as new separatly)
	 *
	 * @param record A newly created SObject instance to be inserted during commitWork
	 * @param relatedToParentField A SObjectField reference to the child field that associates the child record with its parent
	 * @param relatedToParentRecord A SObject instance of the parent record (should also be registered as new separatly)
	 **/
	public void registerNew(SObject record, Schema.sObjectField relatedToParentField, SObject relatedToParentRecord)
	{
		if(record.Id != null)
			throw new UnitOfWorkException('Only new records can be registered as new');
		String sObjectType = record.getSObjectType().getDescribe().getName();			
		if(!m_newListByType.containsKey(sObjectType))
			throw new UnitOfWorkException(String.format('SObject type {0} is not supported by this unit of work', new String[] { sObjectType }));
		m_newListByType.get(sObjectType).add(record);				
		if(relatedToParentRecord!=null && relatedToParentField!=null)
			registerRelationship(record, relatedToParentField, relatedToParentRecord);
	}
	
	/**
	 * Register a relationship between two records that have yet to be inserted to the database. This information will be 
	 *  used during the commitWork phase to make the references only when related records have been inserted to the database.
	 *
	 * @param record An existing or newly created record
	 * @param relatedToField A SObjectField referene to the lookup field that relates the two records together
	 * @param relatedTo A SOBject instance (yet to be commited to the database)
	 */
	public void registerRelationship(SObject record, Schema.sObjectField relatedToField, SObject relatedTo)
	{
		String sObjectType = record.getSObjectType().getDescribe().getName();		
		if(!m_newListByType.containsKey(sObjectType))
			throw new UnitOfWorkException(String.format('SObject type {0} is not supported by this unit of work', new String[] { sObjectType }));
		m_relationships.get(sObjectType).add(record, relatedToField, relatedTo);
	}
	
	/**
	 * Register an existing record to be updated during the commitWork method
	 *
	 * @param record An existing record
	 **/
	public void registerDirty(SObject record)
	{
		if(record.Id == null)
			throw new UnitOfWorkException('New records cannot be registered as dirty');
		String sObjectType = record.getSObjectType().getDescribe().getName();			
		if(!m_dirtyListByType.containsKey(sObjectType))
			throw new UnitOfWorkException(String.format('SObject type {0} is not supported by this unit of work', new String[] { sObjectType }));
		m_dirtyListByType.get(sObjectType).add(record);		
	}
	
	/**
	 * Register an existing record to be deleted during the commitWork method
	 *
	 * @param record An existing record
	 **/
	public void registerDeleted(SObject record)
	{
		if(record.Id == null)
			throw new UnitOfWorkException('New records cannot be registered for deletion');
		String sObjectType = record.getSObjectType().getDescribe().getName();			
		if(!m_deletedListByType.containsKey(sObjectType))
			throw new UnitOfWorkException(String.format('SObject type {0} is not supported by this unit of work', new String[] { sObjectType }));
		m_deletedListByType.get(sObjectType).add(record);							
	}
	
	/**
	 * Takes all the work that has been registered with the UnitOfWork and commits it to the database
	 **/
	public void commitWork()
	{
		// Wrap the work in its own transaction 
		Savepoint sp = Database.setSavePoint();		
		try
		{		
			// Insert by type
			for(Schema.SObjectType sObjectType : m_sObjectTypes)
			{
				m_relationships.get(sObjectType.getDescribe().getName()).resolve();
				insert m_newListByType.get(sObjectType.getDescribe().getName());
			}					
			// Update by type
			for(Schema.SObjectType sObjectType : m_sObjectTypes)
				update m_dirtyListByType.get(sObjectType.getDescribe().getName());		
			// Delete by type (in reverse dependency order)
			Integer objectIdx = m_sObjectTypes.size() - 1;
			while(objectIdx>=0)
				delete m_deletedListByType.get(m_sObjectTypes[objectIdx--].getDescribe().getName());
		}
		catch (Exception e)
		{
			// Rollback
			Database.rollback(sp);
			// Throw exception on to caller
			throw e;
		}
	}
	
	private class Relationships
	{
		private List<Relationship> m_relationships = new List<Relationship>();

		public void resolve()
		{
			// Resolve relationships
			for(Relationship relationship : m_relationships)
				relationship.Record.put(relationship.RelatedToField, relationship.RelatedTo.Id);
		}
		
		public void add(SObject record, Schema.sObjectField relatedToField, SObject relatedTo)
		{
			// Relationship to resolve
			Relationship relationship = new Relationship();
			relationship.Record = record;
			relationship.RelatedToField = relatedToField;
			relationship.RelatedTo = relatedTo;
			m_relationships.add(relationship);
		}
	}
	
	private class Relationship
	{
		public SObject Record;
		public Schema.sObjectField RelatedToField;
		public SObject RelatedTo;
	}
	
	/**
	 * UnitOfWork Exception
	 **/
	public class UnitOfWorkException extends Exception {}

	// SObjects (in order of dependency) used by UnitOfWork in tests bellow	
	private static List<Schema.SObjectType> MY_SOBJECTS = 
		new Schema.SObjectType[] { 
			Product2.SObjectType, 
			PricebookEntry.SObjectType, 
			Opportunity.SObjectType, 
			OpportunityLineItem.SObjectType };
}