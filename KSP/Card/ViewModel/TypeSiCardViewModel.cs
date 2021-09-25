using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.Card.ViewModel
{
    public class TypeSiCardViewModel:CardBaseViewModel<TypeSi>
    {
        private string _name;

        /// <inheritdoc />
        public TypeSiCardViewModel(IDialogService dialogService) : base(dialogService)
        {

            Title = "Карточка Типа Си";
        }

        /// <inheritdoc />
        protected override void AddItem(Context context)
        {
            context.TypeSis.Add(Entity);
        }

        /// <inheritdoc />
        protected override Task<TypeSi> GetEntity(TypeSi parametr, Context context)
        {
            return context.TypeSis.FindAsync(parametr.Id);
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