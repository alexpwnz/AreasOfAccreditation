using System;
using System.Collections;
using System.ComponentModel;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using KSP.Card.ViewModel;
using KSP.Catalog.ViewModel;
using Prism.Commands;
using Prism.Mvvm;
using Prism.Services.Dialogs;

namespace KSP.ViewModel
{
    public class MainWindowViewModel : BindableBase
    {
        #region Public Property

        public MeasuringInstrumentViewModel MeasuringInstrumentViewModel { get; }
        public GroupSiViewModel GroupSiViewModel { get; }
        public DocumentCatalogViewModel DocumentCatalogViewModel { get; }

        public DelegateCommand MeasurementFieldCommand { get; private set; }

        public MICatalogViewModel MICatalogViewModel { get; }

        public DelegateCommand Form2ReportCommand { get; private set; }

        public DelegateCommand RefreshCommand { get; private set; }

        public DelegateCommand InstallationLocationCommand { get; set; }

        public DelegateCommand TypeSiCommand { get; set; }

        public DelegateCommand OrganizationCommand { get; set; }

        public DelegateCommand DocumentTypeCommand { get; private set; }

        #endregion

        #region Field

        private readonly IDialogService _dialogService;

        #endregion

        public MainWindowViewModel(IDialogService dialogService)
        {
            _dialogService = dialogService;
            GroupSiViewModel = new GroupSiViewModel(dialogService);
            DocumentCatalogViewModel = new DocumentCatalogViewModel(dialogService);
            MICatalogViewModel = new MICatalogViewModel(dialogService);
            GroupSiViewModel.PropertyChanged += GroupSiViewModel_PropertyChanged;
            MeasuringInstrumentViewModel = new MeasuringInstrumentViewModel(dialogService);
            InitializedCommand();
          

        }

        private void InitializedCommand()
        {
            RefreshCommand = new DelegateCommand(OnRefreshCommand);
            Form2ReportCommand = new DelegateCommand(OnForm2ReportCommand);
            MeasurementFieldCommand = new DelegateCommand(OnMeasurementFieldCommand);
            DocumentTypeCommand = new DelegateCommand(OnDocumentTypeCommand);
            OrganizationCommand = new DelegateCommand(OnOrganizationCommand);
            TypeSiCommand = new DelegateCommand(OnTypeSiCommand);
            InstallationLocationCommand = new DelegateCommand(OnInstallationLocationCommand);
        }

        private void OnInstallationLocationCommand()
        {
            _dialogService.ShowDialog("InstallationLocationCatalog", null, null);
        }

        private void OnTypeSiCommand()
        {
            _dialogService.ShowDialog("TypeSiCatalog", null, null);
        }

        private void OnOrganizationCommand()
        {
            _dialogService.ShowDialog("OrganizationCatalog", null, null);
        }

        private void OnDocumentTypeCommand()
        {
            _dialogService.ShowDialog("DocumentTypeCatalog", null, null);
        }

        private void OnMeasurementFieldCommand()
        {
            _dialogService.ShowDialog("MeasurementFieldCatalog", null, null);
        }

        private void OnForm2ReportCommand()
        {
            var r = new Report();
            r.Form2();
        }

        private async void GroupSiViewModel_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName == nameof(GroupSiViewModel.Current))
            {
                _cancellationTokenSource?.Cancel();
                _cancellationTokenSource = new CancellationTokenSource();
                MeasuringInstrumentViewModel.Filter = (sender as GroupSiViewModel)?.Current; 
                await MeasuringInstrumentViewModel.RefreshAsync(_cancellationTokenSource.Token);
            }
           
        }
        private CancellationTokenSource _cancellationTokenSource = new CancellationTokenSource();
        private async void OnRefreshCommand()
        {
            try
            {
                await GroupSiViewModel.RefreshAsync(_cancellationTokenSource.Token);
                await DocumentCatalogViewModel.RefreshAsync(_cancellationTokenSource.Token);
                await MICatalogViewModel.RefreshAsync(_cancellationTokenSource.Token);
            }
            catch (TaskCanceledException)
            {
                //ignored
            }
           
        }
    }
}