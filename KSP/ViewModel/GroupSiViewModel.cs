using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using KSP.BD;
using Prism.Services.Dialogs;

namespace KSP.ViewModel
{
    public class GroupSiViewModel : DataViewModelBase<MiGroup>
    {
        /// <inheritdoc />
        protected override void Remove(Context context)
        {
            context.Set<MiGroup>().Attach(Current);
           context.MiGroups.Remove(Current);
        }

        /// <inheritdoc />
        protected override void ShowCard(MiGroup entity)
        {
            var parametr = new DialogParameters();
            parametr.Add(nameof(MiGroup), entity);
            DialogService.ShowDialog("GroupCardView", parametr,null);
        }

        /// <inheritdoc />
        protected override Task<MiGroup[]> LoadData(Context context, CancellationToken token)
        {
           return context.MiGroups.ToArrayAsync(token);
        }

       
        
        /// <inheritdoc />
        public GroupSiViewModel(IDialogService dialogService) : base(dialogService)
        {
        }
    }
}
