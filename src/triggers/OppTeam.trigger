trigger OppTeam on Opportunity (after insert, after update) {
    
//    for(Opportunity o : Trigger.new){
        
 /*       //if there is a change in owner
        if(Trigger.oldmap.get(o.Id).OwnerId != Trigger.newmap.get(o.Id).OwnerId){
            list<OpportunityTeamMember> oppteam = new list<OpportunityTeamMember>();
            OpportunityTeamMember ot = new OpportunityTeamMember();
            //ot.OpportunityId = Trigger.new[0].Id;
            ot.OpportunityId = o.Id;
            //ot.UserId = Trigger.new[0].OwnerId;
            ot.UserId = o.OwnerId;
            ot.TeamMemberRole = 'Opportunity Owner';
            Oppteam.add(ot);
            if(oppteam!=null && oppteam.size()>0){
                insert Oppteam;
            }
        }
*/ 
    /*
        //if there is a change in supported by
        if(Trigger.oldmap.get(o.Id).SupportedBy__c != Trigger.newmap.get(o.Id).SupportedBy__c){
            if (Trigger.oldmap.get(o.Id).SupportedBy__c != null){            
                list<OpportunityTeamMember> oppteamDelete = [select Id from OpportunityTeamMember where (OpportunityId = :o.Id AND UserId = :Trigger.oldmap.get(o.Id).SupportedBy__c)];
                system.debug('>>>>>>>>>' + oppteamDelete);
                delete oppteamDelete;
            }
            if (Trigger.newmap.get(o.Id).SupportedBy__c != null){            
                list<OpportunityTeamMember> oppteamNewSupBy = new list<OpportunityTeamMember>();
                OpportunityTeamMember ot1 = new OpportunityTeamMember();
                ot1.OpportunityId = o.Id;
                ot1.UserId = o.SupportedBy__c;
                ot1.TeamMemberRole = 'Account Manager';
                OppteamNewSupBy.add(ot1);
                if(oppteamNewSupBy!=null && oppteamNewSupBy.size()>0){
                    insert OppteamNewSupBy;
                }
            }
            
        }
    }
    */
}