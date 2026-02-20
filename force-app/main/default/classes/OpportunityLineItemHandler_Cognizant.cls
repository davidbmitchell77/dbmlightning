/* ----------------------------------------------------------------------------------- */
/* COGNIZANT APEX TRIGGER INTERVIEW QUESTION:                                          */
/* ==========================================                                          */
/* Your organization sells products to its customers through opportunities.            */
/* Opportunity can have multiple products (Opportunity Line Items) associated with it. */
/* The organization wants to keep track of the total number of products sold to each   */
/* account and display it on the Account record for reporting purposes.                */
/*------------------------------------------------------------------------------------ */
public class OpportunityLineItemHandler_Cognizant {
    private final TriggerOperation operationType;
    private final String className;

    public OpportunityLineItemHandler_Cognizant(TriggerOperation to) {
        this.operationType = to;
        this.className = String.valueOf(this).substring(0, String.valueOf(this).indexOf(':')) + '.cls';
    }

    public Boolean isValid(List<OpportunityLineItem> opportunityLineItems) {
        Boolean result = true;
        if (opportunityLineItems != null) {
            for (OpportunityLineItem oli : opportunityLineItems) {
                if (nvl(oli.Quantity, 0.00) == 0.00) {
                    oli.Quantity.addError(System.Label.OPPORTUNITY_LINE_ITEM_QUANTITY_IS_REQUIRED);
                    result = false;
                }
            }
        }
        return result;
    }

    public void run(List<OpportunityLineItem> oldLineItems, List<OpportunityLineItem> newLineItems, Map<Id,OpportunityLineItem> oldMap, Map<Id,OpportunityLineItem> newMap) {
        switch on this.operationType {
            when BEFORE_INSERT {

            }
            when BEFORE_UPDATE {

            }
            when BEFORE_DELETE {

            }
            when AFTER_INSERT {
                updateAccounts(newLineItems);
            }
            when AFTER_UPDATE {

            }
            when AFTER_DELETE {
                updateAccounts(oldLineItems);
            }
            when AFTER_UNDELETE {
                updateAccounts(newLineItems);
            }
        }
    }

    private void updateAccounts(List<OpportunityLineItem> opportunityLineLItems) {
        List<Account> accounts = new List<Account>();

        for (AggregateResult agr : [SELECT Opportunity.AccountId, COUNT(Id) products
                                      FROM OpportunityLineItem
                                     WHERE OpportunityId IN :opportunityIds(opportunityLineLItems)
                                  GROUP BY Opportunity.AccountId
        ]) {
            accounts.add(new Account(Id=(Id)agr.get('AccountId'), Number_Of_Products__c=(Decimal)agr.get('products')));
        }

        if (!accounts.isEmpty()) {
            for (Database.SaveResult sr : Database.update(accounts, false)) {
                if (!sr.isSuccess()) {
                    for (Database.Error e : sr.getErrors()) {
                        System.debug(LoggingLevel.ERROR, (this.className + ': ' + e.getStatusCode() + '|' + e.getMessage()));
                    }
                }
            }
        }
    }

    private Set<Id> accountIds(List<Opportunity> opportunities) {
        Set<Id> results = new Set<Id>();
        if (opportunities != null) {
            for (Opportunity o : opportunities) {
                if (o.AccountId != null) {
                    if (!results.contains(o.AccountId)) {
                        results.add(o.AccountId);
                    }
                }
            }
        }
        return results;
    }

    private Set<Id> opportunityIds(List<OpportunityLineItem> opportunityLineItems) {
        Set<Id> results = new Set<Id>();
        if (opportunityLineItems != null) {
            for (OpportunityLineItem oli : opportunityLineItems) {
                if (oli.OpportunityId != null) {
                    if (!results.contains(oli.OpportunityId)) {
                        results.add(oli.OpportunityId);
                    }
                }
            }
        }
        return results;
    }

    private Decimal nvl(Decimal d, Decimal defaultValue) {
        return ((d != null) ? d : defaultValue);
    }
}