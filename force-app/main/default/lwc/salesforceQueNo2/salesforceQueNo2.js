import { LightningElement, wire, track } from 'lwc';
import getProspectingOpps from '@salesforce/apex/SalesforceQueNo2Controller.getProspectingOpps';
import getClosedWonOpps from '@salesforce/apex/SalesforceQueNo2Controller.getClosedWonOpps';
import getClosedLostOpps from '@salesforce/apex/SalesforceQueNo2Controller.getClosedLostOpps';
import updateOpportunityStage from '@salesforce/apex/SalesforceQueNo2Controller.updateOpportunityStage';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SalesforceQueNo2 extends LightningElement {
    searchTerm = '';
    @track prospectingOpps = [];
    @track closedWonOpps = [];
    @track closedLostOpps = [];

    wiredProspecting;
    wiredWon;
    wiredLost;

    @wire(getProspectingOpps, { searchName: '$searchTerm' })
    wiredProspectingMethod(value) {
        this.wiredProspecting = value;
        const { data, error } = value;
        if (data) {
            this.prospectingOpps = data;
        } else if (error) {
            this._showErrorToast('Error loading Prospecting', error);
        }
    }

    @wire(getClosedWonOpps)
    wiredWonMethod(value) {
        this.wiredWon = value;
        const { data, error } = value;
        if (data) {
            this.closedWonOpps = data;
        } else if (error) {
            this._showErrorToast('Error loading Closed Won', error);
        }
    }

    @wire(getClosedLostOpps)
    wiredLostMethod(value) {
        this.wiredLost = value;
        const { data, error } = value;
        if (data) {
            this.closedLostOpps = data;
        } else if (error) {
            this._showErrorToast('Error loading Closed Lost', error);
        }
    }

    handleSearch(event) {
        this.searchTerm = event.detail.value.trim();
        // The reactive wire will auto-refresh when searchTerm changes
    }

    handleDragStart(event) {
        const oppId = event.currentTarget.dataset.id;
        event.dataTransfer.setData('text/plain', oppId);
        event.dataTransfer.effectAllowed = 'move';
    }

    handleDragOver(event) {
        event.preventDefault();
        event.dataTransfer.dropEffect = 'move';
    }

    handleDrop(event) {
        event.preventDefault();
        const newStage = event.currentTarget.dataset.stage;
        const oppId = event.dataTransfer.getData('text/plain');
        if (!oppId || !newStage) return;

        updateOpportunityStage({ oppId, newStage })
            .then((res) => {
                console.log('response from Apex:', res);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Opportunity : ' + res.Id + ' moved to ' + newStage,
                    variant: 'success'
                }));
                return Promise.all([
                    refreshApex(this.wiredProspecting),
                    refreshApex(this.wiredWon),
                    refreshApex(this.wiredLost)
                ]);
            })
            .catch(error => this._showErrorToast('Error updating Opportunity', error));
    }

    _showErrorToast(title, error) {
        const message = (error && error.body && error.body.message) || 'Unknown error';
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: 'error'
        }));
    }
}