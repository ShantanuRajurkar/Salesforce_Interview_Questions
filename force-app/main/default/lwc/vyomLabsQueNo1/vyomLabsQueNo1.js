import { LightningElement } from 'lwc';
import applyJob from '@salesforce/apex/VyomLabsQueNo1Controller.applyJob';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class VyomLabsQueNo1 extends LightningElement {
    // Form field values
    firstName = '';
    lastName = '';
    email = '';
    phone = '';
    position = '';
    resumeSummary = '';

    // Handle input changes for all fields
    handleChange(event) {
        const field = event.target.dataset.field;
        this[field] = event.target.value;
    }

    // Validate and submit the form
    submitApplication() {
        // Simple client-side validation: ensure all required fields are filled
        const inputs = this.template.querySelectorAll('lightning-input, lightning-textarea');
        let allValid = true;
        inputs.forEach(inputCmp => {
            inputCmp.reportValidity();
            if (!inputCmp.checkValidity()) {
                allValid = false;
            }
        });
        if (!allValid) {
            return;
        }

        // Call Apex method to generate PDF and send email
        applyJob({
            firstName: this.firstName,
            lastName: this.lastName,
            email: this.email,
            phone: this.phone,
            position: this.position,
            resumeSummary: this.resumeSummary
        })
        .then(() => {
            // Show success message
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Your application has been sent! Check your email for a copy.',
                variant: 'success'
            }));
            // Optionally, clear the form or perform other actions
            this.firstName = '';
            this.lastName = '';
            this.email = '';
            this.phone = '';
            this.position = '';
            this.resumeSummary = '';
            console.log('First Name:', this.firstName);
            console.log('Last Name:', this.lastName);
        })
        .catch(error => {
            // Show error message
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error sending application',
                message: error.body ? error.body.message : error.message,
                variant: 'error'
            }));
        });
    }
}