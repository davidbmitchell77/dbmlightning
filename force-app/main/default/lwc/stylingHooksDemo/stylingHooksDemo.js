import { LightningElement } from 'lwc';

export default class StylingHooksDemo extends LightningElement {
    className = 'foobar';
    stylingHook = '--slds-c-button-brand-color-background: var(--lwc-brandBackgroundPrimary);';
    i = 0;

    handleClick()  {
        switch(++this.i) {
            case 1:
                this.className = 'green';
                this.stylingHook = '--slds-c-button-brand-color-background: var(--my-color-green)';
                break;
            case 2:
                this.className = 'orange';
                this.stylingHook = '--slds-c-button-brand-color-background: var(--my-color-orange)';
                break;
            case 3:
                this.className = 'pink';
                this.stylingHook = '--slds-c-button-brand-color-background: var(--my-color-pink)';
                break;
            default:
                this.className = 'foobar';
                this.stylingHook = '--slds-c-button-brand-color-background: var(--lwc-brandBackgroundPrimary)';
                this.i = 0;
        }
    }
}