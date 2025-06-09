/*import { LightningElement, wire, track } from 'lwc';
import getProspectingOpps from '@salesforce/apex/SalesforceQueNo2Controller.getProspectingOpps';
import getClosedWonOpps   from '@salesforce/apex/SalesforceQueNo2Controller.getClosedWonOpps';
import getClosedLostOpps  from '@salesforce/apex/SalesforceQueNo2Controller.getClosedLostOpps';
import updateOpportunityStage from '@salesforce/apex/SalesforceQueNo2Controller.updateOpportunityStage';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SalesforceQueNo2 extends LightningElement {
    searchTerm = '';
    @track prospectingOpps = [];
    @track closedWonOpps = [];
    @track closedLostOpps = [];

    // Wire the Apex methods to load data into our lists. Cacheable=true allows use of @wire.
    @wire(getProspectingOpps, { searchName: '$searchTerm' })
    wiredProspecting({ error, data }) {
        if (data) {
            this.prospectingOpps = data;
        } else if (error) {
            this._showErrorToast('Error loading Prospecting opportunities', error);
        }
    }
    @wire(getClosedWonOpps)
    wiredWon({ error, data }) {
        if (data) {
            this.closedWonOpps = data;
        } else if (error) {
            this._showErrorToast('Error loading Closed Won opportunities', error);
        }
    }
    @wire(getClosedLostOpps)
    wiredLost({ error, data }) {
        if (data) {
            this.closedLostOpps = data;
        } else if (error) {
            this._showErrorToast('Error loading Closed Lost opportunities', error);
        }
    }

    // Update searchTerm as user types to re-invoke the wire method
    handleSearch(event) {
        this.searchTerm = event.detail.value.trim();
    }

    // Drag-start handler: set the Opportunity Id on the drag data
    handleDragStart(event) {
        const oppId = event.target.dataset.id;
        event.dataTransfer.setData('text/plain', oppId);
        event.dataTransfer.effectAllowed = 'move'; // Indicate move operation
    }

    // Drag-over handler on drop zones: must call preventDefault() to allow drop
    handleDragOver(event) {
        event.preventDefault();
        event.dataTransfer.dropEffect = 'move';
    }

    // Drop handler: get the Opportunity Id and target stage, then call Apex to update
    handleDrop(event) {
        event.preventDefault();
        const newStage = event.currentTarget.dataset.stage;
        const oppId = event.dataTransfer.getData('text/plain');
        if (!oppId || !newStage) {
            return; // nothing to do
        }
        // Call Apex method to update the stage
        console.log(`Moving Opportunity ${oppId} to stage ${newStage}`);
        updateOpportunityStage({ oppId: oppId, newStage: newStage })
            .then((updatedOpp) => {
                this._moveOppInLists(oppId, updatedOpp.StageName);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Opportunity moved to ' + newStage,
                        variant: 'success'
                    })
                );
            })
            .catch((error) => {
                this._showErrorToast('Error updating Opportunity', error);
            });
    }

    // Helper: move the opportunity object from its old list to the new list in UI
    _moveOppInLists(oppId, newStage) {
        let movedOpp;
        // Remove from prospecting list if present
        if (this.prospectingOpps) {
            this.prospectingOpps = this.prospectingOpps.filter(opp => {
                if (opp.Id === oppId) {
                    movedOpp = opp;
                    return false;
                }
                return true;
            });
        }
        // If not found yet, remove from closed won
        if (!movedOpp && this.closedWonOpps) {
            this.closedWonOpps = this.closedWonOpps.filter(opp => {
                if (opp.Id === oppId) {
                    movedOpp = opp;
                    return false;
                }
                return true;
            });
        }
        // If still not found, remove from closed lost
        if (!movedOpp && this.closedLostOpps) {
            this.closedLostOpps = this.closedLostOpps.filter(opp => {
                if (opp.Id === oppId) {
                    movedOpp = opp;
                    return false;
                }
                return true;
            });
        }
        // If we found the record, update its stage and add it to the appropriate list
        if (movedOpp) {
            movedOpp.StageName = newStage;
            if (newStage === 'Prospecting') {
                this.prospectingOpps = [...this.prospectingOpps, movedOpp];
            } else if (newStage === 'Closed Won') {
                this.closedWonOpps = [...this.closedWonOpps, movedOpp];
            } else if (newStage === 'Closed Lost') {
                this.closedLostOpps = [...this.closedLostOpps, movedOpp];
            }
        }
    }

    // Helper: show a toast in case of errors (aggregates error messages)
    _showErrorToast(title, error) {
        const message = (error && error.body && error.body.message) || error.statusText || 'Unknown error';
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: 'error'
            })
        );
    }
}*/

/*import { LightningElement, wire, track } from 'lwc';
import getProspectingOpps from '@salesforce/apex/SalesforceQueNo2Controller.getProspectingOpps';
import getClosedWonOpps from '@salesforce/apex/SalesforceQueNo2Controller.getClosedWonOpps';
import getClosedLostOpps from '@salesforce/apex/SalesforceQueNo2Controller.getClosedLostOpps';
import updateOpportunityStage from '@salesforce/apex/SalesforceQueNo2Controller.updateOpportunityStage';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SalesforceQueNo2 extends LightningElement {
    searchTerm = '';
    @track prospectingOpps = [];
    @track closedWonOpps = [];
    @track closedLostOpps = [];

    // load functions
    loadAllData() {
        getProspectingOpps({ searchName: this.searchTerm })
            .then(data => { this.prospectingOpps = data; })
            .catch(error => this._showErrorToast('Error loading Prospecting', error));
        getClosedWonOpps()
            .then(data => { this.closedWonOpps = data; })
            .catch(error => this._showErrorToast('Error loading Closed Won', error));
        getClosedLostOpps()
            .then(data => { this.closedLostOpps = data; })
            .catch(error => this._showErrorToast('Error loading Closed Lost', error));
    }

    connectedCallback() {
        this.loadAllData();
    }

    handleSearch(event) {
        this.searchTerm = event.detail.value.trim();
        this.loadAllData();
    }

    handleDragStart(event) {
        const oppId = event.target.dataset.id;
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

        updateOpportunityStage({ oppId: oppId, newStage: newStage })
            .then(() => {
                this.loadAllData();
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Opportunity moved to ' + newStage,
                    variant: 'success'
                }));
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
}*/



// Replace _moveOppInLists with a version that does not rely on filtering from wired lists.
// Instead, reload the data after each update

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