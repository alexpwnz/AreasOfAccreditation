using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Data;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.ViewModel
{
    public class FindMIViewModel:FindBaseViewModel<UnitView>
    {
        private string _factoryNumberFilter;
        private string _nameFilter;
        private string _typeSiFilter;

        /// <inheritdoc />
        public FindMIViewModel(IDialogService dialogService) : base(dialogService)
        {
            Title = "Поиск эталонов";
        }

        

        /// <inheritdoc />
        protected override string[]? SetPropertyFilter()
        {
            return new[] {nameof(FactoryNumberFilter), nameof(TypeSiFilter),nameof(NameFilter) };
        }

        /// <inheritdoc />
        protected override void SaveItem(Context context)
        {
            var parament = Parameters.GetValue<BD.KSP>(nameof(BD.KSP));
            if (parament.FK_MeasuringInstrument == 0)
            {
                parament.FK_MeasuringInstrument = Current.Id;

                context.KSPs.Add(parament);
            }
            else
            {
                context.Set<BD.KSP>().Attach(parament);
                context.Entry(parament).State = EntityState.Modified;
            }
          
          
        }


        public string FactoryNumberFilter
        {
            get => _factoryNumberFilter;
            set =>SetProperty(ref _factoryNumberFilter,value);
        }

        /// <inheritdoc />
        protected override bool SetFilter(UnitView @object)
        {
            if (@object == null) return true;

            bool result= base.SetFilter(@object);
            if (!string.IsNullOrWhiteSpace(FactoryNumberFilter))
            {
                result = result && @object.FactoryNumber.Contains(FactoryNumberFilter);
            }    
            if (!string.IsNullOrWhiteSpace(NameFilter))
            {
                result = result&& @object.TypeSi_Name.Contains(NameFilter);
            }
            if (!string.IsNullOrWhiteSpace(TypeSiFilter))
            {
                result = result && @object.TypeSi_Designation.Contains(TypeSiFilter);
            }
            return result;
        }

        public string NameFilter
        {
            get => _nameFilter;
            set =>SetProperty(ref _nameFilter, value) ;
        }

        public string TypeSiFilter
        {
            get => _typeSiFilter;
            set =>SetProperty(ref _typeSiFilter, value);
        }

        /// <inheritdoc />
        protected override Task<UnitView[]> LoadData(Context context, CancellationToken token)
        {
            return context.UnitViews.ToArrayAsync(token);
        }



        /// <inheritdoc />
        protected override void ShowCard(UnitView entity)
        {
            var parametr = new DialogParameters();
            parametr.Add(nameof(MeasuringInstrument), new MeasuringInstrument { Id = entity.Id });
            DialogService.ShowDialog("MICardView", parametr, null);
        }
    }
}
