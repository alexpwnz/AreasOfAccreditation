using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using KSP.BD;
using KSP.ViewModel;
using Prism.Services.Dialogs;

namespace KSP.Catalog.ViewModel
{
    public abstract class CatalogViewModel<T>:DataViewModelBase<T>, IDialogAware where T : new()
    {
        protected IDialogParameters Parameters { get; private set; }
        /// <inheritdoc />
        protected CatalogViewModel(IDialogService dialogService) : base(dialogService)
        {
        }

    

        /// <inheritdoc />
        public bool CanCloseDialog()
        {
            return true;
        }

        /// <inheritdoc />
        public void OnDialogClosed()
        {
            //throw new NotImplementedException();
        }

        /// <inheritdoc />
        public async void OnDialogOpened(IDialogParameters parameters)
        {
            Parameters = parameters;
              await RefreshAsync(default);
        }

        /// <inheritdoc />
        public string Title { get; protected set; }

        /// <inheritdoc />
        public event Action<IDialogResult> RequestClose;
    }
}
