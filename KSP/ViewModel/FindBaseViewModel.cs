#nullable enable
using System;
using System.ComponentModel;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using KSP.BD;
using KSP.Catalog.ViewModel;
using Prism.Commands;
using Prism.Services.Dialogs;

namespace KSP.ViewModel
{
    public abstract class FindBaseViewModel<T> : CatalogViewModel<T> where T : class, new()
    {

        #region Public Property

        public DelegateCommand AcceptCommand { get; }

        public DelegateCommand<IDialogWindow> CloseDialogCommand { get; }

        #endregion

        /// <inheritdoc />
        protected FindBaseViewModel(IDialogService dialogService) : base(dialogService)
        {
           
            CloseDialogCommand = new DelegateCommand<IDialogWindow>(OnCloseDialogCommand);
            AcceptCommand = new DelegateCommand(OnAcceptCommand, CanAcceptCommand);
            this.PropertyChanged += FindBaseViewModel_PropertyChanged;
            
        }

        private void FindBaseViewModel_PropertyChanged(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName == nameof(Data))
            {
                _collectionView = CollectionViewSource.GetDefaultView(Data);
                return;
            }

            if (SetPropertyFilter()?.FirstOrDefault(q=>q.Equals(e.PropertyName, StringComparison.CurrentCultureIgnoreCase))!=null)
            {
                _collectionView.Filter = o => o == null || SetFilter(o as T);
            }
           
           
        }

        protected virtual bool SetFilter(T @object)
        {
            return true;
        }

        
        protected virtual string[]? SetPropertyFilter()
        {
            return null;
        }

        private ICollectionView _collectionView;
       


        /// <inheritdoc />
        protected override void ChangeCurrent()
        {
            base.ChangeCurrent();
            AcceptCommand.RaiseCanExecuteChanged();
        }

        /// <inheritdoc />
        protected override bool CanRemoveCommand()
        {
            return false;
        }

        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            throw new NotImplementedException();
        }


    
        private bool CanAcceptCommand()
        {
            if (Current == null) return false;
           
            var type = typeof(T);
            var id = (int)type.GetProperty("Id").GetValue(Current);
            return id != 0;
        }

        private void OnCloseDialogCommand(IDialogWindow obj)
        {
            obj.Close();
        }

        protected abstract void SaveItem(Context context);
        protected virtual async void OnAcceptCommand()
        {
            if (Current == null) return;
            using (var context = new Context())

            {
                Task task=null;
                try
                {
                    SaveItem(context);
                    task =  context.SaveChangesAsync();
                    await task;
                }
                catch (Exception e)
                {
                    
                    MessageBox.Show(task.Exception.InnerException.Message);
                }

            }
        }

    }
}