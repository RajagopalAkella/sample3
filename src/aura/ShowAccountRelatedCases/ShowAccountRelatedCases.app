<aura:application >
    <ltng:require styles="/resource/sf1bootstrap/sf1bootstrap/dist/css/bootstrap.min.css,
                          /resource/materialize/materialize/css/materialize.min.css"
                  scripts="/resource/materialize/materialize/js/jquery.js,
                           resource/materialize/materialize/js/materialize.min.js"/>
	
	<div class="col-md-4 account_list">
		<c:AccountList />
	</div>
	
	<div class="col-md-4 create_task">
		<c:CaseList />
	</div>
</aura:application>