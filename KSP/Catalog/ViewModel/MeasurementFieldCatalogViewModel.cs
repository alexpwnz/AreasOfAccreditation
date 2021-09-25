using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.Catalog.ViewModel
{
    public class MeasurementFieldCatalogViewModel:CatalogViewModel<MeasurementField>
    {
        /// <inheritdoc />
        public MeasurementFieldCatalogViewModel(IDialogService dialogService) : base(dialogService)
        {
            Title = "Каталог Области измерения";
        }

        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            context.MeasurementFields.Attach(Current);
            context.MeasurementFields.Remove(Current);
        }

        /// <inheritdoc />
        protected override void ShowCard(MeasurementField entity)
        {
            var parametr = new DialogParameters();
            parametr.Add(nameof(MeasurementField), entity);
            DialogService.ShowDialog("MeasurementFieldCardView", parametr, null);
        }

       
        /// <inheritdoc />
        protected override Task<MeasurementField[]> LoadData(Context context, CancellationToken token)
        {
            return context.MeasurementFields.ToArrayAsync(token);
        }
    }
}
