using System;
using System.Data.Entity;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.Catalog.ViewModel
{
    public class MICatalogViewModel : CatalogViewModel<UnitView>
    {
        /// <inheritdoc />
        public MICatalogViewModel(IDialogService dialogService) : base(dialogService)
        {
        }


        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            throw new NotImplementedException();
        }

        /// <inheritdoc />
        protected override void ShowCard(UnitView entity)
        {
            var parametr = new DialogParameters();
            parametr.Add(nameof(MeasuringInstrument), new MeasuringInstrument { Id = entity.Id});
            DialogService.ShowDialog("MICardView", parametr, null);
        }

        /// <inheritdoc />
        protected override Task<UnitView[]> LoadData(Context context, CancellationToken token)
        {
            var filter = Filter as MiGroup;
            if (filter == null) return context.UnitViews.ToArrayAsync(token);
            return context.UnitViews.Where(q => filter.MiGroupDocuments.Any(d => d.FK_Document == q.Id))
                .ToArrayAsync(token);
        }
    }
}