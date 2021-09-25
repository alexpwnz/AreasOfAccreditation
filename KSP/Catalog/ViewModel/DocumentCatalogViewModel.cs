using System;
using System.Data.Entity;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.Catalog.ViewModel
{
    public class DocumentCatalogViewModel : CatalogViewModel<DocumentView>
    {
        /// <inheritdoc />
        public DocumentCatalogViewModel(IDialogService dialogService) : base(dialogService)
        {
        }


        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            throw new NotImplementedException();
        }

        /// <inheritdoc />
        protected override void ShowCard(DocumentView entity)
        {
            var parametr = new DialogParameters();
            parametr.Add(nameof(Document), new Document{ Id = entity.Id});
            DialogService.ShowDialog("DocumentCardView", parametr, null);
        }

        /// <inheritdoc />
        protected override Task<DocumentView[]> LoadData(Context context, CancellationToken token)
        {
           var filter = Filter as MiGroup;
           if (filter == null) return context.DocumentViews.ToArrayAsync(token);
           return context.DocumentViews.Where(q => filter.MiGroupDocuments.Any(d => d.FK_Document == q.Id))
               .ToArrayAsync(token);



        }

     
    }
}
