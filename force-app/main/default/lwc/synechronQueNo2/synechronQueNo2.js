import { LightningElement, api, wire } from 'lwc';
import { getRelatedListRecords } from 'lightning/uiRelatedListApi';

export default class SynechronQueNo2 extends LightningElement {
  @api recordId;
  @api errors;
  oppData;
  error;

  @wire(getRelatedListRecords, {
    parentRecordId: '$recordId',
    relatedListId: 'Opportunities',
    fields: ['Opportunity.Id', 'Opportunity.Name', 'Opportunity.CloseDate', 'Opportunity.StageName'],
    sortBy: ['CloseDate'],
    pageSize: 200
  })
  wiredOpps({ error, data }) {
    if (data) {
      const ninetyDaysAgo = new Date();
      ninetyDaysAgo.setDate(ninetyDaysAgo.getDate() - 90);
      // Transform and filter
      this.oppData = data.records
        .map(r => {
          const dt = new Date(r.fields.CloseDate.value);
          return {
            Id: r.fields.Id.value,
            Name: r.fields.Name.value,
            StageName: r.fields.StageName.value,
            CloseDate: dt,
            FormattedDate: new Intl.DateTimeFormat('en-GB', {
              year: 'numeric', month: 'long', day: 'numeric'
            }).format(dt),
            StatusClass: r.fields.StageName.value === 'Closed Won'
              ? 'highlight closed-won'
              : 'normal'
          };
        })
        .filter(o => o.CloseDate >= ninetyDaysAgo)
        .sort((a, b) => b.CloseDate - a.CloseDate);
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.oppData = undefined;
    }
  }
}