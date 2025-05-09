import { LightningElement, api } from 'lwc';

import Contact from '@salesforce/schema/Contact';
import Name    from '@salesforce/schema/Contact.Name';
import Title   from '@salesforce/schema/Contact.Title';
import Phone   from '@salesforce/schema/Contact.Phone';
import Email   from '@salesforce/schema/Contact.Email';
import Account from '@salesforce/schema/Contact.AccountId';

export default class RecordEditForm extends LightningElement
{
    @api objectApiName = Contact;
    @api recordId = null;

    fields =
    {
        name: Name,
        title: Title,
        phone: Phone,
        email: Email,
        account: Account
    };

    reset()
    {
        let inputFields = this.template.querySelectorAll("lightning-input-field");

        if (inputFields)
        {
            Array.from(inputFields).forEach(inputField => { inputField.reset(); });
        }
    }
}