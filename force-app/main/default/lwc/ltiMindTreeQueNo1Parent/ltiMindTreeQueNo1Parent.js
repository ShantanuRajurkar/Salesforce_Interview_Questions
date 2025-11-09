import { LightningElement } from 'lwc';

export default class LtiMindTreeQueNo1Parent extends LightningElement {
    // initial sample items (id must be unique)
    items = [
        { id: 'a1', name: 'Alpha', count: 0 },
        { id: 'b2', name: 'Beta',  count: 1 },
        { id: 'c3', name: 'Gamma', count: 2 }
    ];

    // Event handler for 'increment' custom events from child-item
    handleIncrement(event) {
        const idToInc = event.detail?.id;
        if (!idToInc) return;

        // Immutable update: create a NEW array with the updated object
        // This ensures LWC detects the change and re-renders.
        this.items = this.items.map(item =>
            item.id === idToInc ? { ...item, count: item.count + 1 } : item
        );
    }
}