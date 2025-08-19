/**
 * @description       : 
 * @author            : Shantanu Rajurkar
 * @group             : 
 * @last modified on  : 08-16-2025
 * @last modified by  : Shantanu Rajurkar
**/
public with sharing class VyomLabsQueNo1Controller {
    @AuraEnabled
    public static void applyJob(String firstName, String lastName, String email, String phone, String position, String resumeSummary) {
        try {
            // Combine name fields
            String fullName = firstName + ' ' + lastName;
            // Prepare parameters for VF page
            PageReference pdfPage = Page.VyomLabsQueNo1PDF;
            pdfPage.getParameters().put('fullName', fullName);
            pdfPage.getParameters().put('email', email);
            pdfPage.getParameters().put('phone', phone);
            pdfPage.getParameters().put('position', position);
            // Use replace for newlines if needed (to preserve formatting)
            pdfPage.getParameters().put('resumeSummary', resumeSummary);
            // Generate PDF content from the Visualforce page
            Blob pdfContent = pdfPage.getContentAsPDF();
            
            // Create email with PDF attachment
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // No targetObjectId since this is external email
            mail.setToAddresses(new String[] { email });
            mail.setSubject('Your Job Application Submission');
            String body = 'Dear ' + firstName + ',\n\n'
                        + 'Thank you for applying for the ' + position + ' position. Please find attached a copy of your application.\n\n'
                        + 'Best regards,\nHR Team';
            mail.setPlainTextBody(body);

            // Attach PDF file
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            attachment.setFileName('VyomLabsQueNo1PDF.pdf');
            attachment.setBody(pdfContent);
            attachment.setContentType('application/pdf');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment });

            // Send email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        } catch (Exception e) {
            // Propagate exception to LWC (handled in .catch())
            throw new AuraHandledException('Failed to send application: ' + e.getMessage());
        }
    }
}