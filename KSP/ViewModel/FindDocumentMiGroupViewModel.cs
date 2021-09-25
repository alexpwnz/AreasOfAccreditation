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

        public string NumberFilter
        {
            get => _numberFilter;
            set => _numberFilter = value;
        }

        /// <inheritdoc />
        protected override string[]? SetPropertyFilter()
        {
            return new[] { nameof(NumberFilter) };
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
            //if (string.IsNullOrWhiteSpace(@object.FactoryNumber)) return false;
            return @object.Number?.Contains(NumberFilter) ?? true;
            //return .Contains(FactoryNumberFilter);
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
