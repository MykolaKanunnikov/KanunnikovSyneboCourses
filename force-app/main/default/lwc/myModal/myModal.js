import LightningModal from 'lightning/modal';
import addNewSession from '@salesforce/apex/AddSessionController.addNewSession';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MyModal extends LightningModal {
    sessionName;
    sessionDateTime;
    newSession;
    error;
    option = 'info';

    handleCancel() {
        this.close();
    }

    handleChange(event){
        const field = event.target.name;
        if (field === 'sessionName') {
            this.sessionName = event.target.value;
        } else if (field === 'sessionDateTime') {
            this.sessionDateTime = event.target.value;
        }
    }

    handleSave() {
        addNewSession({sessionName: this.sessionName, sessionDateTime: this.sessionDateTime})
        .then((result) => {
            console.log(result);
            if(result.isSuccess) {
                this.option = 'success';
                this.showToast();
                debugger;
                this.newSession = result.responseObj;
                this.error = undefined;
            } else {
                this.option = 'error';
                this.showToast();
                this.newSession = undefined;
                this.error = result.responseObj;
            }
        })
        .catch((error) => {
            this.option = 'error';
            this.showToast();
            this.newSession = undefined;
            this.error = error;
        });
    }

    showToast() {
        const event = new ShowToastEvent({
            title: 'Status',
            variant: this.option,
        });
        this.dispatchEvent(event);
    }

    
}
