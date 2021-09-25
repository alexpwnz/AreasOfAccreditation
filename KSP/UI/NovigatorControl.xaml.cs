using System;
using System.Windows;
using System.Windows.Controls;

namespace KSP.UI
{
    /// <summary>
    /// Логика взаимодействия для NovigatorControl.xaml
    /// </summary>
    public partial class NovigatorControl : UserControl
    {
        public static readonly DependencyProperty FooterTemplateProperty =
            DependencyProperty.RegisterAttached(
                "FooterTemplate",
                typeof(DataTemplate),
                typeof(NovigatorControl),
                new FrameworkPropertyMetadata(
                    new DataTemplate(),
                    OnFooterTemplateChanged));
        public static void SetFooterTemplate(DependencyObject d, DataTemplate value)
        {
            d.SetValue(FooterTemplateProperty, value);
        }
        private static void OnFooterTemplateChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            if (d is NovigatorControl)
                return;

            var view = Utils.FindParent<NovigatorControl>(d);
            if (view != null)
                SetFooterTemplate(view, (DataTemplate)e.NewValue);
            else
            {
                var fe = (FrameworkElement)d;
                fe.Loaded -= FrameworkElement_Loaded;
                fe.Loaded += FrameworkElement_Loaded;
            }
        }
        public static DataTemplate GetFooterTemplate(DependencyObject d)
        {
            return (DataTemplate)d.GetValue(FooterTemplateProperty);
        }
        private static void FrameworkElement_Loaded(object sender, EventArgs e)
        {
            var fe = (FrameworkElement)sender;
            fe.Loaded -= FrameworkElement_Loaded;

            var view = Utils.FindParent<NovigatorControl>(fe);
            if (view != null)
            {
                SetFooterTemplate(view, GetFooterTemplate(fe));
            }
        }
        public NovigatorControl()
        {
            InitializeComponent();
        }
    }
}
