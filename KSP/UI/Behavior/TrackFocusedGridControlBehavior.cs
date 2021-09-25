using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Interactivity;

namespace KSP.UI.Behavior
{
    /// <summary>
    /// Представляет поведение для <see cref="FrameworkElement" />,
    /// позволяющее отслеживать фокус на <see cref="GridControl" />.
    /// </summary>
    public class TrackFocusedGridControlBehavior : Behavior<FrameworkElement>
    {
        public static readonly DependencyProperty FocusedItemProperty =
            DependencyProperty.Register("FocusedItem", typeof(object),
                typeof(TrackFocusedGridControlBehavior));

        public static readonly DependencyProperty FocusedGridProperty =
            DependencyProperty.Register("FocusedGrid", typeof(object),
                typeof(TrackFocusedGridControlBehavior), new PropertyMetadata(OnFocusedGridChanged));

        public static readonly DependencyProperty TargetProperty =
            DependencyProperty.Register("Target", typeof(FrameworkElement),
                typeof(TrackFocusedGridControlBehavior), new PropertyMetadata(OnTargetChanged));

        public static readonly DependencyProperty KeepLastFocusedGridProperty =
            DependencyProperty.Register("KeepLastFocusedGrid", typeof(bool),
                typeof(TrackFocusedGridControlBehavior), new PropertyMetadata(true));

        #region Public Property

        public object FocusedItem
        {
            get => GetValue(FocusedItemProperty);
            set => SetValue(FocusedItemProperty, value);
        }

        public object FocusedGrid
        {
            get => GetValue(FocusedGridProperty);
            set => SetValue(FocusedGridProperty, value);
        }

        public FrameworkElement Target
        {
            get => (FrameworkElement) GetValue(TargetProperty);
            set => SetValue(TargetProperty, value);
        }

        public bool KeepLastFocusedGrid
        {
            get => (bool) GetValue(KeepLastFocusedGridProperty);
            set => SetValue(KeepLastFocusedGridProperty, value);
        }

        #endregion

        #region Field

        private readonly RoutedEventHandler _elementGotKeyboardFocus;

        #endregion

        public TrackFocusedGridControlBehavior()
        {
            _elementGotKeyboardFocus = OnElementGotKeyboardFocus;
        }

        private static void OnFocusedGridChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            var b = (TrackFocusedGridControlBehavior) d;
            if (e.OldValue is DataGrid ogc)
                ogc.CurrentCellChanged -= b.GridControl_CurrentItemChanged;
            if (e.NewValue is DataGrid ngc)
            {
                b.SetValue(FocusedItemProperty, ngc.CurrentItem);
                ngc.CurrentCellChanged += b.GridControl_CurrentItemChanged;
            }

            //if (e.OldValue is PivotGridControl oldPivotGrid)
            //    oldPivotGrid.FocusedCellChanged -= b.PivotGrid_FocusedCellChanged;
            //if (e.NewValue is PivotGridControl newPivotGrid)
            //    newPivotGrid.FocusedCellChanged += b.PivotGrid_FocusedCellChanged;
        }

        private static void OnTargetChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            var b = (TrackFocusedGridControlBehavior) d;

            ((FrameworkElement) e.OldValue)?.RemoveHandler(UIElement.GotKeyboardFocusEvent, b._elementGotKeyboardFocus);
            ((FrameworkElement) e.NewValue)?.AddHandler(UIElement.GotKeyboardFocusEvent, b._elementGotKeyboardFocus,
                true);

            if (e.NewValue == null)
                b.AssociatedObject.AddHandler(UIElement.GotKeyboardFocusEvent, b._elementGotKeyboardFocus, true);
            else
                b.AssociatedObject.RemoveHandler(UIElement.GotKeyboardFocusEvent, b._elementGotKeyboardFocus);
        }

        /// <inheritdoc />
        protected override void OnAttached()
        {
            base.OnAttached();
            AssociatedObject.AddHandler(UIElement.GotKeyboardFocusEvent, _elementGotKeyboardFocus, true);
        }

        private void OnElementGotKeyboardFocus(object sender, RoutedEventArgs e)
        {
            object grid;
            if (e.OriginalSource is DataGrid /*|| e.OriginalSource is PivotGridControl*/)
            {
                grid = e.OriginalSource;
            }
            else
            {
                grid = Utils.FindParent<DataGrid>((DependencyObject) e.OriginalSource, AssociatedObject);
                if (grid == null)
                    //grid = Utils.FindParent<PivotGridControl>((DependencyObject)e.OriginalSource, AssociatedObject);
                    if (KeepLastFocusedGrid && grid == null)
                        return;
            }

            FocusedGrid = grid;
        }

        private void GridControl_CurrentItemChanged(object sender, EventArgs eventArgs)
        {
            FocusedItem = ((DataGrid) sender).CurrentItem;
        }
    }
}