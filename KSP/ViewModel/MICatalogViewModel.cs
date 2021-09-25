using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using KSP.BD;
using KSP.Card.ViewModel;
using Prism.Services.Dialogs;

namespace KSP.ViewModel
{
    public class MICatalogViewModel: MeasuringInstrumentViewModel
    {
        /// <inheritdoc />
        public MICatalogViewModel(IDialogService dialogService) : base(dialogService)
        {
        }

        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            base.Remove(context);
        }

        /// <inheritdoc />
        protected override void ShowCard(UnitView entity)
        {
            var parametr = new DialogParameters();
            var measuring = new MeasuringInstrument();
            measuring.Id = entity.Id;
            parametr.Add(nameof(MeasuringInstrument), measuring);
            DialogService.ShowDialog("MICardView", parametr, null);
        }
    }
}
