import { LightningElement } from 'lwc';
import MyModal from "c/myModal";


export default class sessionViewButton extends LightningElement {

    async handleClick() {       
        const result = await MyModal.open({
            size: 'large',
            description: 'Accessible description of modal\'s purpose',
            content: 'Passed into content api',
        });
        console.log(result);
    }

}
