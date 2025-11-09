import { LightningElement, api } from 'lwc';

export default class LtiMindTreeQueNo1Child extends LightningElement {
     @api item; // receives the whole item object from parent

    onIncrementClick() {
        // dispatch a custom event with the item's id
        this.dispatchEvent(new CustomEvent('increment', {
            detail: { id: this.item?.id },
            bubbles: true,
            composed: true
        }));
    }
}