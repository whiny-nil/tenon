module Tenon
  module PieceHelper
    def piece_image_tag(piece, options = {})
      responsive_image_tag(piece, options, Tenon.config.front_end[:breakpoints])
    end

    def backend_piece_image_tag(piece, options = {})
      responsive_image_tag(piece, options, Tenon.config.back_end[:breakpoints])
    end

    private
      def responsive_image_tag(piece, options = {}, breakpoints)
        srcset = generate_srcset(piece)
        sizes = generate_sizes(piece, breakpoints)
        image_tag(piece.image.url(:x2000), options.merge(srcset: srcset, sizes: sizes))
      end

      def generate_sizes(piece, breakpoints)
        # handle 'twelve' pieces that have size set to '' in the db
        piece_size = piece.size == '' ? 'twelve' : piece.size

        # go through the defined breakpoints and lookup the tenon_content sizes for the type of item this piece's row belongs to. default to sizes[:default] width if not defined
        breakpoints.map do |name, sizes|
          "(min-width: #{sizes[:browser]}px) #{(piece.sizes[piece_size.to_sym] / 12 * 100 * content_size(sizes, piece) / sizes[:browser]).to_i}vw"
        end.join(', ')
      end

      def generate_srcset(piece)
        piece.styles.map do |name, width|
          if piece.image.attachment.exists?(computed_style(piece, name).to_sym)
            "#{piece.image.attachment.url(computed_style(piece, name).to_sym)} #{width}w"
          end
        end.join(', ')
      end

      def computed_style(piece, style)
        computed_style = "#{piece.image.style_prefix}_#{style}"
      end

      def content_size(sizes, piece)
        sizes[piece.row.item_type.demodulize.downcase.to_sym] || sizes[:default] || sizes[:browser]
      end
  end
end
