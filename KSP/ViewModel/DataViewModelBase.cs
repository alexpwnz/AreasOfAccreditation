using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Threading;
using KSP.BD;
using Prism.Commands;
using Prism.Mvvm;
using Prism.Services.Dialogs;
using System.Threading.Tasks;

namespace KSP.ViewModel
{
    public abstract class DataViewModelBase<T> : BindableBase where T : new()
    {
        protected CancellationTokenSource CancellationTokenSource { get; set; } = new CancellationTokenSource();
        private object _filter;

        public object Filter
        {
            get => _filter;
            set => SetProperty(ref _filter, value);
        }

        protected DataViewModelBase(IDialogService dialogService)
        {
            this.DialogService = dialogService;
            RefreshCommand = new DelegateCommand(OnRefreshCommand);
            AddCommand = new DelegateCommand(OnAddCommand);
            EditCommand = new DelegateCommand(OnEditCommand, CanEditCommand);
            RemoveCommand = new DelegateCommand(OnRemoveCommand, CanRemoveCommand);
        }

        private bool IsAvailabilityCurrent()
        {
            if (Current == null) return false;
            var type = typeof(T);
            var id = (int)type.GetProperty("Id").GetValue(Current);
            return id != 0;
        }
        protected virtual bool CanRemoveCommand()
        {
            return IsAvailabilityCurrent();
        }

        protected virtual bool CanEditCommand()
        {
            return IsAvailabilityCurrent();
        }
        

        public DelegateCommand RemoveCommand { get; }

        protected virtual async void OnRemoveCommand()
        {
            using (var context = new Context())
            {
                Remove(context);
                await context.SaveChangesAsync();
            }
            await RefreshAsync(CancellationTokenSource.Token);
        }

        protected abstract void Remove(Context context);

        public DelegateCommand EditCommand { get; }

        private async void  OnEditCommand()
        {
            ShowCard(Current);
            await this.RefreshAsync(CancellationTokenSource.Token);
        }

        protected abstract void ShowCard(T entity);

        public DelegateCommand AddCommand { get; }

        private void OnAddCommand()
        {
            ShowCard(new T());
            this.RefreshAsync(CancellationTokenSource.Token);
        }

        public DelegateCommand RefreshCommand { get; }

        private async void OnRefreshCommand()
        {
            await RefreshAsync(CancellationTokenSource.Token);
        }

        public T Current
        {
            get => _current;
            set => SetProperty(ref _current, value == null ? _current : value, ChangeCurrent);
        }

        protected virtual void ChangeCurrent()
        {
            EditCommand.RaiseCanExecuteChanged();
            RemoveCommand.RaiseCanExecuteChanged();
        }

        private T[] _data;
        private T _current;
        protected readonly IDialogService DialogService;

        public T[] Data
        {
            get => _data;
            set => SetProperty(ref _data, value);
        }

        protected abstract Task<T[]> LoadData(Context context, CancellationToken token);

        public virtual async Task RefreshAsync(CancellationToken token)
        {

            using (var context = new Context())
            {
                var res = await LoadData(context, token);
                if (token.IsCancellationRequested)
                {
                    CancellationTokenSource = new CancellationTokenSource();
                    return;
                }

                Data = res.Length == 0 ? new[] { new T() } : res;
            }

            Current ??= Data.FirstOrDefault();
        }
    }
}