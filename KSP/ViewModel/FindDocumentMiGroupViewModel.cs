using System.Data.Entity;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.ViewModel
{
    public class FindDocumentMiGroupViewModel: FindBaseViewModel<DocumentView>
    {
        private string _numberFilter;
        private string _nameFilter;
        private string _documentTypeFilter;

        public string NumberFilter
        {
            get => _numberFilter;
            set => _numberFilter = value;
        }
        public string NameFilter
        {
            get => _nameFilter;
            set => _nameFilter = value;
        }
        public string DocumentTypeFilter
        {
            get => _documentTypeFilter;
            set => _documentTypeFilter = value;
        }
        
        /// <inheritdoc />
        protected override string[]? SetPropertyFilter()
        {
            return new[] { nameof(NumberFilter), nameof(NameFilter), nameof(DocumentTypeFilter) };
        }

        /// <inheritdoc />
        protected override void SaveItem(Context context)
        {
            var parament = Parameters.GetValue<MiGroupDocument>(nameof(MiGroupDocument));
            parament.FK_Document = Current.Id;
            context.MiGroupDocuments.Add(parament);
        }

      
        /// <inheritdoc />
        protected override bool SetFilter(DocumentView @object)
        {
            if (@object == null) return true;

            bool result = base.SetFilter(@object);
            if (!string.IsNullOrWhiteSpace(NumberFilter))
            {
                result = result && @object.Number.Contains(NumberFilter);
            }
            if (!string.IsNullOrWhiteSpace(NameFilter))
            {
                result = result && @object.Name.Contains(NameFilter);
            }
            if (!string.IsNullOrWhiteSpace(DocumentTypeFilter))
            {
                result = result && @object.DocumentType_Name.Contains(DocumentTypeFilter);
            }
            return result;
        }

     
        /// <inheritdoc />
        protected override Task<DocumentView[]> LoadData(Context context, CancellationToken token)
        {
            return context.DocumentViews.ToArrayAsync(token);
        }



        /// <inheritdoc />
        protected override void ShowCard(DocumentView entity)
        {
            var parametr = new DialogParameters();
            parametr.Add(nameof(Document), new Document { Id = entity.Id });
            DialogService.ShowDialog("FindDocumentMiGroupView", parametr, null);
        }


        /// <inheritdoc />
        public FindDocumentMiGroupViewModel(IDialogService dialogService) : base(dialogService)
        {
        }
    }
}
