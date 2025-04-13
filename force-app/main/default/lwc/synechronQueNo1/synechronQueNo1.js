import { LightningElement, track, wire } from 'lwc';
import getCases from '@salesforce/apex/CaseController.getCases';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class SynechronQueNo1 extends LightningElement {
    @track searchKey = '';
    @track pageNumber = 1;
    @track pageSize = 10;
    @track isModalOpen = false;
    @track selectedCaseId;
    @track isFirstPage = true;
    @track isLastPage = false;
    @track cases;

    // Store wired Apex response for refreshApex
    wiredCasesResult;

    columns = [
        { label: 'Case Number', fieldName: 'CaseNumber' },
        { label: 'Subject', fieldName: 'Subject' },
        { label: 'Status', fieldName: 'Status' },
        { label: 'Priority', fieldName: 'Priority' },
        {
            type: 'button',
            typeAttributes: {
                label: 'Update',
                name: 'update',
                title: 'Update',
                disabled: false,
                value: 'update',
                iconPosition: 'left'
            }
        }
    ];


    // Reactive wire service to get the cases data
    @wire(getCases, { searchKey: '$searchKey', pageNumber: '$pageNumber', pageSize: '$pageSize' })
    wiredCases(result) {
        this.wiredCasesResult = result;
        if (result.data) {
            this.cases = result.data;
            this.isFirstPage = this.pageNumber === 1;
            this.isLastPage = result.data.length < this.pageSize;
        } else if (result.error) {
            console.error('Error fetching cases: ', result.error);
        }
    }


    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
    }

    // When search is initiated, reset to the first page (the wired call refreshes automatically)
    handleSearch() {
        this.pageNumber = 1;
    }

    handlePrevious() {
        if (this.pageNumber > 1) {
            this.pageNumber--;
        }
    }

    handleNext() {
        if (!this.isLastPage) {
            this.pageNumber++;
        }
    }

    // Opens the modal on clicking the Update button
    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'update') {
            this.selectedCaseId = row.Id;
            this.isModalOpen = true;
        }
    }

    closeModal() {
        this.isModalOpen = false;
    }
    
    // Called when the lightning-record-edit-form successfully saves the record
    handleFormSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Case updated successfully',
                variant: 'success'
            })
        );
        this.isModalOpen = false;
        // Refresh the wired Apex call to get updated case data
        refreshApex(this.wiredCasesResult);
    }
    
    handleFormError(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error updating case',
                message: event.detail.message,
                variant: 'error'
            })
        );
    }
}
