using System.Windows;
using KSP.Card.View;
using KSP.Card.ViewModel;
using KSP.Catalog.View;
using KSP.Catalog.ViewModel;
using KSP.View;
using KSP.ViewModel;
using Prism.Ioc;
using Prism.Mvvm;

namespace KSP
{
    /// <summary>
    /// Логика взаимодействия для App.xaml
    /// </summary>
    public partial class App
    {
        protected override Window CreateShell()
        {
            return Container.Resolve<MainWindowView>();
        }

        protected override void RegisterTypes(IContainerRegistry containerRegistry)
        {
            containerRegistry.RegisterDialog<FindMIView, FindMIViewModel>();
            containerRegistry.RegisterDialog<FindDocumentMiGroupView, FindDocumentMiGroupViewModel>();
            containerRegistry.RegisterDialog<FindDocumenttOwnershipView,FindDocumentOwnershipViewModel>();

            #region Catalog

            containerRegistry.RegisterDialog<MeasurementFieldCatalogView, MeasurementFieldCatalogViewModel>(
                "MeasurementFieldCatalog");
            containerRegistry.RegisterDialog<DocumentTypeCatalogView, DocumentTypeCatalogViewModel>(
                "DocumentTypeCatalog");
            containerRegistry.RegisterDialog<InstallationLocationCatalogView, InstallationLocationCatalogViewModel>(
                "InstallationLocationCatalog");
            containerRegistry.RegisterDialog<TypeSiCatalogView, TypeSiCatalogViewModel>("TypeSiCatalog");
            containerRegistry.RegisterDialog<OrganizationCatalogView, OrganizationCatalogViewModel>(
                "OrganizationCatalog");

            #endregion Catalog

            #region Card

            containerRegistry.RegisterDialog<GroupCardView, GroupCardViewModel>();
            containerRegistry.RegisterDialog<MeasurementFieldCardView, MeasurementFieldCardViewModel>();
            containerRegistry.RegisterDialog<DocumentTypeCardView, DocumentTypeCardViewModel>();
            containerRegistry.RegisterDialog<MICardView, MICardViewModel>();
            containerRegistry.RegisterDialog<DocumentCardView, DocumentCardViewModel>();
            containerRegistry.RegisterDialog<InstallationLocationCardView, InstallationLocationCardViewModel>();
            containerRegistry.RegisterDialog<OrganizationCardView, OrganizationCardViewModel>();
            containerRegistry.RegisterDialog<TypeSiCardView, TypeSiCardViewModel>();

            #endregion Card

            //containerRegistry.RegisterDialog<CatalogView, CatalogViewModel<DocumentType>>("DocumentType");
            //containerRegistry.RegisterForNavigation<ReportView>();
        }

        /// <inheritdoc />
        protected override void ConfigureViewModelLocator()
        {
            base.ConfigureViewModelLocator();
            ViewModelLocationProvider.Register(typeof(MainWindowView).ToString(), typeof(MainWindowViewModel));
            //ViewModelLocationProvider.Register(typeof(GroupCardView).ToString(), typeof(GroupCardViewModel));
            //ViewModelLocationProvider.Register(typeof(ProgramView).ToString(), typeof(ProgramViewModel));
        }
    }
}