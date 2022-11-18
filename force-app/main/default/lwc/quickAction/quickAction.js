import { LightningElement, api, wire } from 'lwc';
import showRooms from '@salesforce/apex/QuickActionController.showRooms';

export default class QuickAction extends LightningElement {
    columns = [{ label: 'Rooms', fieldName: 'Name' }];
    @api recordId;
    @wire(showRooms, {recordId: '$recordId'})
    record;
}