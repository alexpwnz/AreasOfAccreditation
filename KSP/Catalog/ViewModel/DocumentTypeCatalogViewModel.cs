using System.Data.Entity;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.Catalog.ViewModel
{
    public class DocumentTypeCatalogViewModel:CatalogViewModel<DocumentType>
    {
        /// <inheritdoc />
        public DocumentTypeCatalogViewModel(IDialogService dialogService) : base(dialogService)
        {
            Title = "Каталог Типов документов";
        }

        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            context.DocumentTypes.Attach(Current);
            context.DocumentTypes.Remove(Current);
        }

        /// <inheritdoc />
        protected override void ShowCard(DocumentType entity)
        {
            var parametr = new DialogParameters();
            parametr.Add(nameof(DocumentType), entity);
            DialogService.ShowDialog("DocumentTypeCardView", parametr, null);
        }

       
        /// <inheritdoc />
        protected override Task<DocumentType[]> LoadData(Context context, CancellationToken token)
        {
            return context.DocumentTypes.ToArrayAsync(token);
        }
    }
}