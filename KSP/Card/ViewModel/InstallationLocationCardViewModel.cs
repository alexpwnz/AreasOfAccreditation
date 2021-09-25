using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.Card.ViewModel
{
    public class InstallationLocationCardViewModel:CardBaseViewModel<InstallationLocation>
    {
        private string _name;

        /// <inheritdoc />
        public InstallationLocationCardViewModel(IDialogService dialogService) : base(dialogService)
        {

            Title = "Карточка Места установки";
        }

        /// <inheritdoc />
        protected override void AddItem(Context context)
        {
            context.InstallationLocations.Add(Entity);
        }

        /// <inheritdoc />
        protected override Task<InstallationLocation> GetEntity(InstallationLocation parametr, Context context)
        {
            return context.InstallationLocations.FindAsync(parametr.Id);
        }

        /// <inheritdoc />
        protected override async Task SynchronizationAsync(Context context, SynchronizationDirection synchronizationDirection)
        {
            switch (synchronizationDirection)
            {
                case SynchronizationDirection.Direct:
                    Name = Entity.Name;
                    break;
                case SynchronizationDirection.Reverse:
                    Entity.Name = Name;
                    break;
            }
        }

        public string Name
        {
            get => _name;
            set => SetProperty(ref _name, value);
        }
    }
}
