import { LightningElement, api } from 'lwc';

import Name          from '@salesforce/schema/Contact.Name';
import Street        from '@salesforce/schema/Contact.MailingStreet';
import City          from '@salesforce/schema/Contact.MailingCity';
import State         from '@salesforce/schema/Contact.MailingState';
import PostalCode    from '@salesforce/schema/Contact.MailingPostalCode';
import Country       from '@salesforce/schema/Contact.MailingCountry';

const FIELDS = [ Name, Street, City, State, PostalCode, Country ];

export default class LightningRecordFormCompact extends LightningElement {
    @api recordId;
    @api objectApiName;

    fields = FIELDS;
}