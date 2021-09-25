using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.Card.ViewModel
{
    public class OrganizationCardViewModel : CardBaseViewModel<Organization>
    {
        #region Public Property

        public string Country
        {
            get => _country;
            set => SetProperty(ref _country, value);
        }


        public string Region
        {
            get => _region;
            set => SetProperty(ref _region, value);
        }

        public string LegalForm
        {
            get => _legalForm;
            set => SetProperty(ref _legalForm, value);
        }

        public string Name
        {
            get => _name;
            set => SetProperty(ref _name, value);
        }

        #endregion

        #region Field

        private string _country;
        private string _legalForm;
        private string _name;
        private string _region;

        #endregion

        /// <inheritdoc />
        public OrganizationCardViewModel(IDialogService dialogService) : base(dialogService)
        {
            Title = "Карточка Организации";
        }

        /// <inheritdoc />
        protected override void AddItem(Context context)
        {
            context.Organizations.Add(Entity);
        }

        /// <inheritdoc />
        protected override Task<Organization> GetEntity(Organization parametr, Context context)
        {
            return context.Organizations.FindAsync(parametr.Id);
        }

        /// <inheritdoc />
        protected override async Task SynchronizationAsync(Context context,
            SynchronizationDirection synchronizationDirection)
        {
            switch (synchronizationDirection)
            {
                case SynchronizationDirection.Direct:
                    Name = Entity.Name;
                    Region = Entity.Region;
                    Country = Entity.Country;
                    LegalForm = Entity.LegalForm;
                    break;
                case SynchronizationDirection.Reverse:
                    Entity.Name = Name;
                    Entity.Country = Country;
                    Entity.LegalForm = LegalForm;
                    Entity.Region = Region;
                    break;
            }
        }
    }
}