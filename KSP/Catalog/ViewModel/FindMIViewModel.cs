using System;
using System.Data;
using System.Data.Entity;
using System.Linq;
using KSP.BD;
using Prism.Commands;
using Prism.Mvvm;
using Prism.Services.Dialogs;

namespace KSP.Catalog.ViewModel
{
    public class FindMIViewModel : BindableBase, IDialogAware
    {
        public FindMIViewModel()
        {
            CloseDialogCommand = new DelegateCommand<IDialogWindow>(OnCloseDialogCommand);
            AcceptCommand = new DelegateCommand(OnAcceptCommand);
            var dsdsa = new DataView();
        }

        private void OnCloseDialogCommand(IDialogWindow obj)
        {
            obj.Close();
        }

        public DelegateCommand<IDialogWindow> CloseDialogCommand { get; set; }

        public DelegateCommand AcceptCommand { get; set; }

        private async void OnAcceptCommand()
        {
            if (Current != null)
            {
                using (var context = new Context())
                {
                    var ksp = new BD.KSP
                    {
                        FK_MiGroup = _ksp.FK_MiGroup,
                        FK_MeasuringInstrument = ((UnitView) Current).Id
                    };
                    context.KSPs.Add(ksp);

                    await context.SaveChangesAsync();
                }
            }
            OnDialogClosed();
        }

        private UnitView[] _data;
        private object _current;

        public UnitView[] Data
        {
            get => _data;
            set => SetProperty(ref _data, value);
        }

        public object Current
        {
            get => _current;
            set => SetProperty(ref _current, value ?? _current);
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
        public void OnDialogOpened(IDialogParameters parameters)
        {
            //throw new NotImplementedException();
        }

        private BD.KSP _ksp;

        /// <inheritdoc />
        public async void OnDialogOpenedAsync(IDialogParameters parameters)
        {
            _ksp = parameters.GetValue<BD.KSP>(nameof(KSP));
            using (var context = new Context())
            {
                Data = await context.UnitViews.ToArrayAsync();
                Current = Data?.FirstOrDefault(q => q.Id == _ksp.FK_MeasuringInstrument);
            }
        }

        /// <inheritdoc />
        public string Title { get; }

        /// <inheritdoc />
        public event Action<IDialogResult> RequestClose;
    }

}