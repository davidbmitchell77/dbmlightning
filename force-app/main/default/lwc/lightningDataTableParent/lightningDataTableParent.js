import { LightningElement, api, wire } from 'lwc';
import { guid, uuid, showToast       } from 'c/utils';

import getContacts from '@salesforce/apex/ContactController.getContacts';

const COLUMNS = [
    { type: 'text',  label: 'First Name', fieldName: 'FirstName',  editable: false, sortable: true },
    { type: 'text',  label: 'Last Name',  fieldName: 'LastName',   editable: false, sortable: true },
    { type: 'url',   label: 'Title',      fieldName: 'ContactUrl', editable: false, sortable: true, typeAttributes: { label: { fieldName: 'Title'      } }, target: '_blank' },
    { type: 'url',   label: 'Account',    fieldName: 'AccountUrl', editable: false, sortable: true, typeAttributes: { label: { fieldName: 'AccountName'} }, target: '_blank' },
    { type: 'phone', label: 'Phone',      fieldName: 'Phone',      editable: true,  sortable: true },
    { type: 'email', label: 'Email',      fieldName: 'Email',      editable: true,  sortable: true },
];

export default class LightningDataTableParent extends LightningElement {

    @api recordId;
    @api accountName;

    cols   = COLUMNS;
    data   = [];
    height = '20.5rem';
    mode   = 'fixed';

    connectedCallback() {
        this.accountName = (this.recordId ? this.recordId : this.accountName);
        this.height = (this.recordId ? '8.0rem' : this.height);
        console.info(`utils.guid(): ${guid()}`);
        console.info(`utils.uuid(): ${uuid()}`);
    }

    @wire(getContacts, { accountName: "$accountName", lwcName: 'lightningDataTableParent' })
    handle(response) {
        let { data, error } = response;
        if (data) {
            console.info(data);
            let temp = data.map((contact) => {
                return {
                    ...contact,
                    ContactUrl:  (`${window.location.origin}/${contact.Id}`),
                    AccountName: (`${contact.Account.Name}`),
                    AccountUrl:  (`${window.location.origin}/${contact.AccountId}`),
                    Title:       (contact.hasOwnProperty('Title') ? contact.Title : '(no title)')
                };
            });
            this.data = [ ...temp ];
        }
        else if (error) {
             console.error(error);
             showToast(this, 'Error retrieving list of contacts!', error.body.message, 'error', 'sticky');
        }
    }

    handleClick(event) {
        let message = `You clicked the ${event.target.label} button!`;
        let variant = 'info';
        switch (event.target.label) {
            case 'Base':
                variant = 'info';
                break;
            case 'Neutral':
                variant = 'info';
                break;
            case 'Brand':
                variant = 'info';
                break;
            case 'Destructive':
                variant = 'error';
                break;
            case 'Destructive Text':
                variant = 'warning';
                break;
            case 'Success':
                variant = 'success';
                break;
            default:
                variant = 'info';
        }
        this.log(message);
        showToast(this, 'Button click detected!', message, variant);
    }

    handleInput(event) {
        this.accountName = (event.target.value ? event.target.value : '_');
    }

    handlePaste(event) {
        this.accountName = (event.clipboardData || window.clipboardData).getData('text');
    }

    log(message) {
        const Logger = this.template.querySelector('c-logger');
        Logger.info(message);
        Logger.saveLog();
    }

    errorCallback(error, stack) {
        let message = (typeof(error) === 'object' ? JSON.stringify(error) : error);
        if (error.hasOwnProperty('body.message')) { message = error.body.message; }
        if (error.hasOwnProperty('message'     )) { message = error.message;      }
        try {
            const Logger = this.template.querySelector('c-logger');
            Logger.error(message).addTag('lwc').addTag('platformEventDemo');
            Logger.error(stack  ).addTag('lwc').addTag('platformEventDemo');
            Logger.saveLog();
        }
        catch(e) {
            console.warn('Nebula Logger:', e);
            console.error(message);
            console.error(stack);
        }
        showToast(this, 'Child Web Component Error!', message, 'error', 'sticky');
    }
}