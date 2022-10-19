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
    public class DocumentTypeCardViewModel : CardBaseViewModel<DocumentType>
    {
        private string _name;

        /// <inheritdoc />
        public DocumentTypeCardViewModel(IDialogService dialogService) : base(dialogService)
        {
        }

        /// <inheritdoc />
        protected override void AddItem(Context context)
        {
            context.DocumentTypes.Add(Entity);
        }

        /// <inheritdoc />
        protected override Task<DocumentType> GetEntity(DocumentType parametr, Context context)
        {
            return context.DocumentTypes.FindAsync(parametr.Id);
        }

        /// <inheritdoc />
        protected override async Task SynchronizationAsync(Context context, SynchronizationDirection synchronizationDirection, CancellationToken token)
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
            set => SetProperty(ref _name , value);
        }
    }
}
