using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.Card.ViewModel
{
    /// <summary>
    /// The measurement field card view model.
    /// </summary>
    public class MeasurementFieldCardViewModel:CardBaseViewModel<MeasurementField>
    {
        private string _code;
        private string _name;

        /// <inheritdoc />
        public MeasurementFieldCardViewModel(IDialogService dialogService) : base(dialogService)
        {

            Title = "Карточка Области измерения";
        }

        /// <inheritdoc />
        protected override void AddItem(Context context)
        {
            context.MeasurementFields.Add(Entity);
        }

        /// <inheritdoc />
        protected override Task<MeasurementField> GetEntity(MeasurementField parametr, Context context)
        {
            return context.MeasurementFields.FindAsync(parametr.Id);
        }

        /// <inheritdoc />
        protected override async Task SynchronizationAsync(Context context, SynchronizationDirection synchronizationDirection, CancellationToken token)
        {
            switch (synchronizationDirection)
            {
                case SynchronizationDirection.Direct:
                    Code = Entity.Code;
                    Name = Entity.Name;
                    break;
                case SynchronizationDirection.Reverse:
                    Entity.Code =Code ;
                    Entity.Name = Name ;
                    break;
            }
        }

        public string Code
        {
            get => _code;
            set =>SetProperty(ref _code,value) ;
        }

        public string Name
        {
            get => _name;
            set => SetProperty(ref _name, value);
        }
    }
}
