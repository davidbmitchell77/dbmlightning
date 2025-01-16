({
	doInit : function(component, event, helper)
    {
		component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Address', fieldName: 'BillingStreet', type: 'text'},
            {label: 'City', fieldName: 'BillingCity', type: 'text'},
            {label: 'State', fieldName: 'BillingState', type: 'text'},
            {label: 'Postal Code', fieldName: 'BillingPostalCode', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', type: 'phone'}
        ]);
	}
})