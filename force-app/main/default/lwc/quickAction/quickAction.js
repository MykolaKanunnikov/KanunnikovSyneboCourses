import { LightningElement, api } from 'lwc';
import showRooms from '@salesforce/apex/QuickActionController.showRooms';

export default class QuickAction extends LightningElement {
    columns = [{ label: 'Rooms', fieldName: 'Name' }];
    data;

    _recordId;
    @api set recordId(value) {
        this._recordId = value;
        this.data = showRooms({recordId: this._recordId});
    }

    get recordId() {
        return this._recordId;
    }

}