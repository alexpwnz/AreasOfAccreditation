using System.Data.Entity;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.Catalog.ViewModel
{
    public class TypeSiCatalogViewModel:CatalogViewModel<TypeSi>
    {
        /// <inheritdoc />
        public TypeSiCatalogViewModel(IDialogService dialogService) : base(dialogService)
        {
            Title = "Каталог Типов СИ";
        }

        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            context.TypeSis.Attach(Current);
            context.TypeSis.Remove(Current);
        }

        /// <inheritdoc />
        protected override void ShowCard(TypeSi entity)
        {
            var parametr = new DialogParameters();
            parametr.Add(nameof(TypeSi), entity);
            DialogService.ShowDialog("TypeSiCardView", parametr, null);
        }

       
        /// <inheritdoc />
        protected override Task<TypeSi[]> LoadData(Context context, CancellationToken token)
        {
            return context.TypeSis.ToArrayAsync(token);
        }
    }
}