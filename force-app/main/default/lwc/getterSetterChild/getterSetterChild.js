import { LightningElement, api } from 'lwc';

export default class GetterSetterChild extends LightningElement {
    phone;

    @api
    get phoneNumber() {
        return this.phone;
    }

    set phoneNumber(value) {
        this.phone = this.format(value);
    }

    format(s) {
        let areaCode = s.substring(0,3);
        let prefix = s.substring(3,6);
        let number = s.substring(6,10);
        return '(' + areaCode + ') ' + prefix + '-' + number;
    }
}