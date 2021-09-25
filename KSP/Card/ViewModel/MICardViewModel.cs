using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using KSP.ViewModel;
using Prism.Mvvm;
using Prism.Services.Dialogs;

namespace KSP.Card.ViewModel
{
    public class MICardViewModel : CardBaseViewModel<MeasuringInstrument>
    {
        private TypeSi[] _typeSiList;
        private TypeSi _typeSi;
        private string _factoryNumber;
        private string _inventoryNumber;
        private string _registrationNumber;
        private DateTime? _issueDate;
        private DateTime? _commissioningDate;
        private InstallationLocation[] _installationLocationList;
        private InstallationLocation _installationLocation;
        private Organization[] _ownershipList;
        private Organization _ownership;
        private Organization[] _organizationList;
        private Organization _manufacturer;

        public TypeSi[] TypeSiList
        {
            get => _typeSiList;
            set => SetProperty(ref _typeSiList, value);
        }

        public TypeSi TypeSi
        {
            get => _typeSi;
            set => SetProperty(ref _typeSi, value);
        }

        public string FactoryNumber
        {
            get => _factoryNumber;
            set => SetProperty(ref _factoryNumber, value);
        }

        public string InventoryNumber
        {
            get => _inventoryNumber;
            set => SetProperty(ref _inventoryNumber, value);
        }

        public string RegistrationNumber
        {
            get => _registrationNumber;
            set => SetProperty(ref _registrationNumber, value);
        }

        public DateTime? IssueDate
        {
            get => _issueDate;
            set => SetProperty(ref _issueDate, value);
        }

        public DateTime? CommissioningDate
        {
            get => _commissioningDate;
            set => SetProperty(ref _commissioningDate, value);
        }

        public InstallationLocation[] InstallationLocationList
        {
            get => _installationLocationList;
            set => SetProperty(ref _installationLocationList, value);
        }

        public InstallationLocation InstallationLocation
        {
            get => _installationLocation;
            set => SetProperty(ref _installationLocation, value);
        }


        public Organization Ownership
        {
            get => _ownership;
            set => SetProperty(ref _ownership, value);
        }

        public Organization[] OrganizationList
        {
            get => _organizationList;
            set => SetProperty(ref _organizationList, value);
        }

        public Organization Manufacturer
        {
            get => _manufacturer;
            set => SetProperty(ref _manufacturer, value);
        }

        public Document_MIViewModel DocumentMIViewModel { get; set; }

        public VerificationToolViewModel VerificationToolViewModel { get; set; }

        /// <inheritdoc />
        public MICardViewModel(IDialogService dialogService) : base(dialogService)
        {
            Title = "Карточка СИ";
            DocumentMIViewModel = new Document_MIViewModel(dialogService);
            VerificationToolViewModel = new VerificationToolViewModel(dialogService);
        }


        /// <inheritdoc />
        protected override void AddItem(Context context)
        {
            context.MeasuringInstruments.Add(Entity);
        }

        /// <inheritdoc />
        protected override Task<MeasuringInstrument> GetEntity(MeasuringInstrument parametr, Context context)
        {
            return context.MeasuringInstruments.FindAsync(parametr.Id);
        }

        /// <inheritdoc />
        protected override async Task SynchronizationAsync(Context context, SynchronizationDirection synchronizationDirection)
        {
            
            switch (synchronizationDirection)
            {
                case SynchronizationDirection.Direct:
                    VerificationToolViewModel.Filter = Entity;
                    DocumentMIViewModel.Filter = Entity;
                    DocumentMIViewModel.RefreshAsync(default);
                    VerificationToolViewModel.RefreshAsync(default);
                    OrganizationList = await context.Organizations.ToArrayAsync();
                    TypeSiList = await context.TypeSis.ToArrayAsync();
                    InstallationLocationList = await context.InstallationLocations.ToArrayAsync();
                    FactoryNumber = Entity.FactoryNumber;
                    InventoryNumber = Entity.InventoryNumber;
                    RegistrationNumber = Entity.RegistrationNumber;
                    IssueDate = Entity.IssueDate;
                    CommissioningDate = Entity.CommissioningDate;
                    Ownership = OrganizationList.FirstOrDefault(q=>q.Id== Entity.FK_Ownership) ;
                    Manufacturer = OrganizationList.FirstOrDefault(q => q.Id == Entity.FK_Manufacturer);
                    TypeSi = TypeSiList.FirstOrDefault(q => q.Id == Entity.FK_TypeSi);
                    InstallationLocation = InstallationLocationList.FirstOrDefault(q => q.Id == Entity.FK_InstallationLocation);
                    break;
                case SynchronizationDirection.Reverse:
                    Entity.FactoryNumber= FactoryNumber;
                    Entity.InventoryNumber= InventoryNumber;
                    Entity.RegistrationNumber= RegistrationNumber;
                    Entity.IssueDate= IssueDate;
                    Entity.CommissioningDate= CommissioningDate;
                    Entity.FK_Ownership = Ownership.Id;
                    Entity.FK_Manufacturer = Manufacturer.Id;
                    Entity.FK_TypeSi = TypeSi.Id;
                    Entity.FK_InstallationLocation = InstallationLocation.Id;
                    break;
            }
        }
    }

    public class Document_MIViewModel : DataViewModelBase<DocumentView>
    {
        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            var fltr = Filter as MeasuringInstrument;
            var res = context.TitleOwnershipDeeds.FirstOrDefault(q => q.FK_MeasuringInstrument == fltr.Id && q.FK_Document == Current.Id);
            context.TitleOwnershipDeeds.Remove(res);
        }

        /// <inheritdoc />
        protected override void ShowCard(DocumentView entity)
        {
            var parametr = new DialogParameters();
            var ownershipDeed = new TitleOwnershipDeed();
            ownershipDeed.FK_MeasuringInstrument = ((MeasuringInstrument)Filter).Id;
            ownershipDeed.FK_Document = entity.Id;
            parametr.Add(nameof(TitleOwnershipDeed), ownershipDeed);
            DialogService.ShowDialog("FindDocumenttOwnershipView", parametr, null);
        }

        /// <inheritdoc />
        protected override Task<DocumentView[]> LoadData(Context context, CancellationToken token)
        {
            return Filter == null ? context.DocumentViews.ToArrayAsync(token)
                : context.DocumentViews.Where(q => context.TitleOwnershipDeeds.Any(k => k.FK_Document == q.Id && k.FK_MeasuringInstrument == ((MeasuringInstrument)Filter).Id)).ToArrayAsync(token);
        }



        /// <inheritdoc />
        public Document_MIViewModel(IDialogService dialogService) : base(dialogService)
        {

        }
    }

    public class VerificationToolViewModel : DataViewModelBase<VerificationTool>
    {
        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            var fltr = Filter as VerificationTool;
            var res = context.TitleOwnershipDeeds.FirstOrDefault(q => q.FK_MeasuringInstrument == fltr.Id && q.FK_Document == Current.Id);
            context.TitleOwnershipDeeds.Remove(res);
        }

        /// <inheritdoc />
        protected override void ShowCard(VerificationTool entity)
        {
            var parametr = new DialogParameters();
            parametr.Add(nameof(VerificationTool), Filter);
            DialogService.ShowDialog("___", parametr, null);
        }

        /// <inheritdoc />
        protected override Task<VerificationTool[]> LoadData(Context context, CancellationToken token)
        {
            return Filter == null ? context.VerificationTools.ToArrayAsync(token)
                : context.VerificationTools.Where(q =>q.FK_MeasuringInstrument==((MeasuringInstrument)Filter).Id).ToArrayAsync(token);
        }



        /// <inheritdoc />
        public VerificationToolViewModel(IDialogService dialogService) : base(dialogService)
        {

        }
    }

    //public class MiGroupViewModel : DataViewModelBase<MiG>
    //{
    //    /// <inheritdoc />
    //    protected override void Remove(Context context)
    //    {
    //        var fltr = Filter as VerificationTool;
    //        var res = context.TitleOwnershipDeeds.FirstOrDefault(q => q.FK_MeasuringInstrument == fltr.Id && q.FK_Document == Current.Id);
    //        context.TitleOwnershipDeeds.Remove(res);
    //    }

    //    /// <inheritdoc />
    //    protected override void ShowCard(VerificationTool entity)
    //    {
    //        var parametr = new DialogParameters();
    //        parametr.Add(nameof(VerificationTool), Filter);
    //        DialogService.ShowDialog("___", parametr, null);
    //    }

    //    /// <inheritdoc />
    //    protected override Task<VerificationTool[]> LoadData(Context context)
    //    {
    //        return Filter == null ? context.VerificationTools.ToArrayAsync()
    //            : context.VerificationTools.Where(q => q.FK_MeasuringInstrument == ((MeasuringInstrument)Filter).Id).ToArrayAsync();
    //    }



    //    /// <inheritdoc />
    //    public MiGroupViewModel(IDialogService dialogService) : base(dialogService)
    //    {

    //    }
    //}
}
