using System;
using System.Data.Entity;
using System.Data.Entity.Migrations;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using KSP.BD;
using Prism.Commands;
using Prism.Mvvm;
using Prism.Services.Dialogs;

namespace KSP.Card.ViewModel
{
    public abstract class CardBaseViewModel<T> : BindableBase, IDialogAware where T : new()
    {
        private T _entity;
        private string _title;
        private CancellationTokenSource _cancellationTokenSource;

        #region Public Property

        /// <summary>
        /// Позволяет получить команду подтверждения операции.
        /// </summary>
        public DelegateCommand AcceptCommand { get; }

        /// <summary>
        /// Позволяет получить команду обновления данных.
        /// </summary>
        public DelegateCommand RefreshCommand { get; }

        /// <summary>
        /// Позволяет получить команду закрытия окна.
        /// </summary>
        public DelegateCommand<IDialogWindow> CloseDialogCommand { get; }

        /// <summary>
        /// Позволяет задать или получить сущность карточки.
        /// </summary>
        public T Entity
        {
            get => _entity;
            set =>  SetProperty(ref _entity ,value);
        }
        

        #endregion

        /// <summary>
        /// Инициализирует и создает экземпляр <see cref="CardBaseViewModel"/> класса.
        /// </summary>
        /// <param name="dialogService">The dialog service.</param>
        protected CardBaseViewModel(IDialogService dialogService)
        {
            _cancellationTokenSource = new CancellationTokenSource();
            RefreshCommand = new DelegateCommand(OnRefreshCommand);
            CloseDialogCommand = new DelegateCommand<IDialogWindow>(OnCloseDialogCommand);
            AcceptCommand = new DelegateCommand(OnAcceptCommand);
        }

        #region ${Implements Interface} Members

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
            if (parameters == null) throw new NullReferenceException($@"{nameof(parameters)} not initialized");
            var parametr = parameters.GetValue<T>(typeof(T).Name);

            lock (_cancellationTokenSource)
            {
                _cancellationTokenSource?.Cancel();
                _cancellationTokenSource = null;
                _cancellationTokenSource = new CancellationTokenSource();
            }
            using (var context = new Context())
            {
                var type = typeof(T);
                Entity = (int) type.GetProperty("Id")?.GetValue(parametr) != 0
                    ? await GetEntity(parametr, context)
                    : new T();
                await SynchronizationAsync(context, SynchronizationDirection.Direct, _cancellationTokenSource.Token);
            }
        }

        /// <inheritdoc />
        public string Title
        {
            get => _title; 
            set => SetProperty(ref _title, value);
        }

        /// <inheritdoc />
        public event Action<IDialogResult> RequestClose;

        #endregion

        private void OnCloseDialogCommand(IDialogWindow window)
        {
            window.Close();
        }

        protected abstract void AddItem(Context context);

        private async void OnAcceptCommand()
        {
            using (var context = new Context())
            {
                var type = typeof(T);
                var id = (int) type.GetProperty("Id").GetValue(Entity);

                lock (_cancellationTokenSource)
                {
                    _cancellationTokenSource?.Cancel();
                    _cancellationTokenSource = null;
                    _cancellationTokenSource = new CancellationTokenSource();
                }
                await SynchronizationAsync(context, SynchronizationDirection.Reverse, _cancellationTokenSource.Token);
                if (id == 0)
                {
                    AddItem(context);
                }
                else
                {
                    context.Entry(Entity).State = EntityState.Modified;
                }

                try
                {
                    await context.SaveChangesAsync();
                }
                catch (System.Data.SqlClient.SqlException e)
                {
                    MessageBox.Show(e.Message);
                }
                
            }
            RaisePropertyChanged(nameof(Entity));
        }

        private void OnRefreshCommand()
        {
            using Context context = new Context();
            lock (_cancellationTokenSource)
            {
                _cancellationTokenSource?.Cancel();
                _cancellationTokenSource = null;
                _cancellationTokenSource = new CancellationTokenSource();
            }
            SynchronizationAsync(context, SynchronizationDirection.Direct, _cancellationTokenSource.Token);
        }


        protected abstract Task<T> GetEntity(T parametr, Context context);

        protected abstract Task SynchronizationAsync(Context context, SynchronizationDirection direction, CancellationToken token);

        #region Nested type: SynchronizationDirection

        protected enum SynchronizationDirection
        {
            Direct,
            Reverse
        }

        #endregion
    }
}