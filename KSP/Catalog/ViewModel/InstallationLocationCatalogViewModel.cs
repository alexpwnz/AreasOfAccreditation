using System.Data.Entity;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.Catalog.ViewModel
{
    public class InstallationLocationCatalogViewModel:CatalogViewModel<InstallationLocation>
    {
        /// <inheritdoc />
        public InstallationLocationCatalogViewModel(IDialogService dialogService) : base(dialogService)
        {
            Title = "Каталог Мест установки";
        }

        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            context.InstallationLocations.Attach(Current);
            context.InstallationLocations.Remove(Current);
        }

        /// <inheritdoc />
        protected override void ShowCard(InstallationLocation entity)
        {
            var parametr = new DialogParameters();
            parametr.Add(nameof(InstallationLocation), entity);
            DialogService.ShowDialog("InstallationLocationCardView", parametr, null);
        }

       
        /// <inheritdoc />
        protected override Task<InstallationLocation[]> LoadData(Context context, CancellationToken token)
        {
            return context.InstallationLocations.ToArrayAsync(token);
        }
    }
}