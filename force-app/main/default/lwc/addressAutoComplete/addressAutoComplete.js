import { LightningElement, api } from 'lwc';
import { ShowToastEvent        } from 'lightning/platformShowToastEvent';

export default class AddressAutoComplete extends LightningElement {
    @api recordId;
    @api objectAPIName;

    strStreet;
    strCity;
    strState;
    strCountry;
    strPostalCode;

    handleSuccess(event) {
        console.info('Updated record id: ', event.detail.id);
        this.dispatchEvent(
            new ShowToastEvent({ title: 'Successful Record Update', message: 'Record updated successfully.', variant: 'success'})
        );
    }

    handleSubmit(event) {
        const fields = event.detail.fields;
        console.info('Fields are ' + JSON.stringify(fields));
        event.preventDefault();
        if (this.objectAPIName === 'Account') {
            fields.BillingStreet = this.strStreet;
            fields.BillingCity = this.strCity;
            fields.BillingState = this.strState;
            fields.BillingCountry = this.strCountry;
            fields.BillingPostalCode = this.strPostalCode;
        }
        else if (this.objectAPIName === 'Contact') {
            fields.MailingStreet = this.strStreet;
            fields.MailingCity = this.strCity;
            fields.MailingState = this.strState;
            fields.MailingCountry = this.strCountry;
            fields.MailingPostalCode = this.strPostalCode;
        }
        this.template.querySelector( 'lightning-record-edit-form' ).submit( fields );
    }

    addressInputChange(event) {
        this.strStreet = event.target.street;
        this.strCity = event.target.city;
        this.strState = event.target.province;
        this.strCountry = event.target.country;
        this.strPostalCode = event.target.postalCode;
    }
}