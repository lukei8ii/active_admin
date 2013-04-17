module ActiveAdmin
  module Views

    class ModalSection < ActiveAdmin::Component

      attr_reader :collection
      builder_method :modal_section

      # Takes a ActiveAdmin::Sidebar::Section instance
      def build(section)

        @section = section
        self.id = @section.id

        script do
          text_node "
            function #{self.id}(e) {
              $.fbmodal({
                id    : &apos;#{self.id}&apos;,
                type  : &apos;#{@section.modal_type}&apos;,
                title : &apos;#{@section.title}&apos;,
                text  : &apos;#{self.id}_body&apos;,
                href   : &apos;#{@section.href}&apos;,
                method : &apos;#{@section.method}&apos;,
                loading: &apos;#{I18n.t('active_admin.modal.loading')}&apos;
              });
            }
          "
        end

        if @section.method == 'partial'
          div :id => "#{self.id}_wrapper", :style => 'display:none;' do
            div :id => "#{self.id}_body", :class => 'modal_content' do
              text_node raw build_modal_content
            end
          end
        end
      end


      protected

      def build_modal_content
        if @section.block
          rvalue = instance_eval(&@section.block)
          self << rvalue if rvalue.is_a?(String)
        else
          render(@section.partial_name)
        end
      end

    end

  end
end