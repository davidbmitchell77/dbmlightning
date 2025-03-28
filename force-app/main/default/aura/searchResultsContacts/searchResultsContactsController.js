({
	doInit : function(component, event, helper)
    {
		component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Address', fieldName: 'MailingStreet', type: 'text'},
            {label: 'City', fieldName: 'MailingCity', type: 'text'},
            {label: 'State', fieldName: 'MailingState', type: 'text'},
            {label: 'Postal Code', fieldName: 'MailingPostalCode', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', type: 'phone'},
        ]);
	}
})