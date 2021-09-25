using System.Data.Entity;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.Catalog.ViewModel
{
    public class OrganizationCatalogViewModel:CatalogViewModel<Organization>
    {
        /// <inheritdoc />
        public OrganizationCatalogViewModel(IDialogService dialogService) : base(dialogService)
        {
            Title = "Каталог Организаций";
        }

        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            context.Organizations.Attach(Current);
            context.Organizations.Remove(Current);
        }

        /// <inheritdoc />
        protected override void ShowCard(Organization entity)
        {
            var parametr = new DialogParameters();
            parametr.Add(nameof(Organization), entity);
            DialogService.ShowDialog("OrganizationCardView", parametr, null);
        }

       
        /// <inheritdoc />
        protected override Task<Organization[]> LoadData(Context context, CancellationToken token)
        {
            return context.Organizations.ToArrayAsync(token);
        }
    }
}