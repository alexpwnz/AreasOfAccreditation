using KSP.BD;

using Prism.Services.Dialogs;

using System;
using System.Data.Entity;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace KSP.Card.ViewModel
{
    public class DocumentCardViewModel : CardBaseViewModel<Document>
    {
        private DateTime? _date;
        private string _name;
        private string _number;
        private DocumentType _documentType;
        private DocumentType[] _documentTypes;
        private CardBaseViewModel<Document> _cardBaseViewModelImplementation;

        public string Name
        {
            get => _name;
            set =>SetProperty(ref _name, value);
        }

        public string Number
        {
            get => _number;
            set => SetProperty(ref _number, value) ;
        }

        public DocumentType DocumentType
        {
            get => _documentType;
            set =>SetProperty(ref _documentType, value) ;
        }

        public DocumentType[] DocumentTypes
        {
            get => _documentTypes;
            set => SetProperty(ref _documentTypes,value);
        }

        public DateTime? Date
        {
            get => _date;
            set => SetProperty(ref _date,value) ;
        }

        /// <inheritdoc />
        protected override void AddItem(Context context)
        {
            context.Documents.Add(Entity);
        }

        /// <inheritdoc />
        protected override Task<Document> GetEntity(Document parametr, Context context)
        {
            return context.Documents.FindAsync(parametr.Id);
        }

        /// <inheritdoc />
        protected override async Task SynchronizationAsync(Context context, SynchronizationDirection synchronizationDirection, CancellationToken token)
        {
            switch (synchronizationDirection)
            {
                case SynchronizationDirection.Direct:
                    DocumentTypes = await context.DocumentTypes.OrderBy(q => q.Name).ToArrayAsync(token);
                    //MeasuringInstrumentViewModel.Filter = Entity;
                    //DocumentCatalogViewModel.Filter = Entity;
                    Name = Entity?.Name;
                    Number = Entity?.Number;
                    Date = Entity?.Date;
                    DocumentType = DocumentTypes.FirstOrDefault(q => q.Id == Entity?.FK_DocumentType);
                    break;

                case SynchronizationDirection.Reverse:
                    Entity.Name = Name;
                    Entity.Number = Number;
                    Entity.Date = Date;
                    Entity.FK_DocumentType = DocumentType.Id;
                    break;
            }
        }

        /// <inheritdoc />
        public DocumentCardViewModel(IDialogService dialogService) : base(dialogService)
        {
            Title = "Карточка документа";
        }
    }
}