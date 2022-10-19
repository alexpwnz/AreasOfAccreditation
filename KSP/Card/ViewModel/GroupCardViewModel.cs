using System.Data.Entity;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using KSP.Catalog.ViewModel;
using KSP.ViewModel;
using Prism.Services.Dialogs;

namespace KSP.Card.ViewModel
{
   
    public class GroupCardViewModel : CardBaseViewModel<MiGroup>
    {
        public Document_MiGroupViewModel DocumentMiGroupViewModel { get; }
        public MeasuringInstrumentViewModel MeasuringInstrumentViewModel { get; }
        public GroupCardViewModel(IDialogService dialogService):base(dialogService)
        {

            Title = "Карточка Группы СИ";
            DocumentMiGroupViewModel = new Document_MiGroupViewModel(dialogService);
            MeasuringInstrumentViewModel = new MeasuringInstrumentViewModel(dialogService);
        }


        /// <inheritdoc />
        protected override void AddItem(Context context)
        {
            context.MiGroups.Add(Entity);
        }

       
        /// <inheritdoc />
        protected override Task<MiGroup> GetEntity(MiGroup parametr, Context context)
        {
            return context.MiGroups.FindAsync(parametr.Id);
        }

        /// <inheritdoc />
        protected override async Task SynchronizationAsync(Context context, SynchronizationDirection synchronizationDirection, CancellationToken token)
        {
            switch (synchronizationDirection)
            {
                case SynchronizationDirection.Direct:
                    MeasurementFieldList = await context.MeasurementFields.OrderBy(q => q.Code).ToArrayAsync(token);
                    MeasuringInstrumentViewModel.Filter = Entity;
                    DocumentMiGroupViewModel.Filter = Entity;
                    MeasuringInstrumentViewModel.RefreshAsync(token);
                    DocumentMiGroupViewModel.RefreshAsync(token);
                    Code = Entity?.Code;
                    Range = Entity?.Range;
                    Name = Entity?.Name;
                    Characteristic = Entity?.Characteristic;
                    MeasurementField = MeasurementFieldList.FirstOrDefault(q => q.Id == Entity?.FK_MeasurementField);
                    break;
                case SynchronizationDirection.Reverse:
                    Entity.Code = Code;
                    Entity.Range = Range;
                    Entity.Name = Name;
                    Entity.Characteristic = Characteristic;
                    Entity.FK_MeasurementField = MeasurementField.Id;
                    break;
            }
         
        }





        private string _name;
        private string _range;
        private string _characteristic;
        private string _code;
        private MeasurementField _measurementField;
        private MeasurementField[] _measurementFieldList;

        public MeasurementField[] MeasurementFieldList
        {
            get => _measurementFieldList;
            set => SetProperty(ref _measurementFieldList, value);
        }

        public string Name
        {
            get => _name;
            set => SetProperty(ref _name, value);
        }

        public string Range
        {
            get => _range;
            set => SetProperty(ref _range, value);
        }

        public string Characteristic
        {
            get => _characteristic;
            set => SetProperty(ref _characteristic, value);
        }

        public string Code
        {
            get => _code;
            set => SetProperty(ref _code, value);
        }

        public MeasurementField MeasurementField
        {
            get => _measurementField;
            set => SetProperty(ref _measurementField, value);
        }
       
    } 
    public class Document_MiGroupViewModel: DataViewModelBase<DocumentView>
    {
      

        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            var fltr = Filter as MiGroup;
            var res = context.MiGroupDocuments.FirstOrDefault(q => q.FK_MiGroup == fltr.Id&& q.FK_Document== Current.Id);
            context.MiGroupDocuments.Remove(res);
        }

        /// <inheritdoc />
        protected override void ShowCard(DocumentView entity)
        {
            var parametr = new DialogParameters();
            var groupDocument = new MiGroupDocument();
            groupDocument.FK_MiGroup= ((MiGroup)Filter).Id;
            groupDocument.FK_Document = entity.Id;
            parametr.Add(nameof(MiGroupDocument), groupDocument);
            DialogService.ShowDialog("FindDocumentMiGroupView", parametr, null);
        }

        /// <inheritdoc />
        protected override Task<DocumentView[]> LoadData(Context context, CancellationToken token)
        {
            return Filter == null ? context.DocumentViews.ToArrayAsync(token) 
                : context.DocumentViews.Where(q => context.MiGroupDocuments.Any(k => k.FK_Document == q.Id && k.FK_MiGroup == ((MiGroup)Filter).Id)).ToArrayAsync(token);
        }

       

        /// <inheritdoc />
        public Document_MiGroupViewModel(IDialogService dialogService) : base(dialogService)
        {
           
        }
    }
    public class MeasuringInstrumentViewModel : DataViewModelBase<UnitView>
    {


        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            var fltr = Filter as MiGroup;
            var res = context.KSPs.FirstOrDefault(q => q.FK_MiGroup == fltr.Id && q.FK_MeasuringInstrument == Current.Id);
            context.KSPs.Remove(res);
        }

        /// <inheritdoc />
        protected override void ShowCard(UnitView entity)
        {
            var parametr = new DialogParameters();
            var newksp = new BD.KSP();
            newksp.FK_MiGroup = ((MiGroup)Filter).Id;
            newksp.FK_MeasuringInstrument = entity.Id;
            parametr.Add(nameof(KSP), newksp);
            DialogService.ShowDialog("FindMIView", parametr, null);
        }

        /// <inheritdoc />
        protected override Task<UnitView[]> LoadData(Context context, CancellationToken token)
        {
            return Filter == null ? context.UnitViews.ToArrayAsync(token)
                : context.UnitViews.Where(q => context.KSPs.Any(k => k.FK_MeasuringInstrument == q.Id && k.FK_MiGroup == ((MiGroup)Filter).Id)).ToArrayAsync(token);
        }



        /// <inheritdoc />
        public MeasuringInstrumentViewModel(IDialogService dialogService) : base(dialogService)
        {

        }
    }
}