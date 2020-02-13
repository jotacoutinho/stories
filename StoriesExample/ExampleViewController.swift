//
//  ExampleViewController.swift
//  Stories
//
//  Created by João Pedro De Souza Coutinho on 10/02/20.
//  Copyright © 2020 João Pedro De Souza Coutinho. All rights reserved.
//

import Foundation
import UIKit
import Stories

final class ExampleViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var storiesContainerView: StoriesCollectionView! {
        didSet {
            storiesContainerView.mainColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
            storiesContainerView.secondaryColor = UIColor(red: 170/255, green: 60/255, blue: 50/255, alpha: 1)
        }
    }
    
    // MARK: Variables
    private let transition = CircularScaleTransition()
    private var transitioningViewFrame: CGRect = CGRect(origin: .zero, size: .zero)
    weak var storiesDelegate: StoriesDelegate?
    private var stories: [[String]] = [[""]]

    // MARK: Life Cycle
    init() {
        super.init(nibName: String(describing: "ExampleViewController"), bundle: .main)
        self.view.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urls = ["https://f0.pngfuel.com/png/742/932/black-and-white-logo-illustration-guitar-hero-rock-band-bass-guitar-logo-guitar-png-clip-art.png",
                    "https://www.alternativenation.net/wp-content/uploads/2019/08/acdclogored.jpg",
                    "https://cdn.imgbin.com/19/13/0/imgbin-blink-182-album-neighborhoods-music-california-blink-blink-Sr6YzbW5HWv7pm2cgqz9xPicb.jpg",
                    "https://supermusicas.com.br/wp-content/uploads/2018/05/pen-drive-com-musicas-charlie-brown-jr.jpg",
                    "https://i.pinimg.com/originals/ab/ab/34/abab3424128727a422de1c22d4a19227.jpg",
                    "https://cdn11.bigcommerce.com/s-sq9zkarfah/images/stencil/1280x1280/products/124616/117885/Eagles-Rock-Band-Logo-Vinyl-Decal-Sticker__01928.1507850687.jpg?c=2?imbypass=on",
                    "https://contactarts.loja2.com.br/img/1a9bd56b21aee25bdd3865c9f1692f99.png",
                    "https://i.pinimg.com/originals/19/6f/01/196f014d213ab96382602c4ccebc403e.jpg",
                    "https://www.logolynx.com/images/logolynx/3b/3b708b78472ceb1ec20da04292cdfa31.gif",
                    "https://i.pinimg.com/originals/56/9e/23/569e23880d53b32323944ec5bdf52fe6.jpg",
                    "https://live.staticflickr.com/3272/3070179560_7d8c76e6ec_b.jpg",
                    "https://www.spirit-of-metal.com/les%20goupes/K/Kansas/pics/1479720_logo.jpg",
                    "https://img2.gratispng.com/20180616/zka/kisspng-linkin-park-logo-minutes-to-midnight-musical-ensem-linkin-park-5b253d50ba0935.918139041529167184762.jpg",
                    "https://hyperpix.net/wp-content/uploads/2019/08/metallica-logo-font-download.jpg",
                    "https://i.ebayimg.com/00/s/NzY4WDEwMjQ=/z/VwAAAOSw4A5YvAEa/$_57.JPG?set_id=8800005007",
                    "https://i.pinimg.com/originals/b3/7c/f9/b37cf9b8be63b08057a9e62e7c68da28.jpg",
                    "https://images-na.ssl-images-amazon.com/images/I/61R7gJadP7L._AC_SX425_.jpg",
                    "https://rollingstone.uol.com.br/media/_versions/queen_-_logo__reproducao_widelg.jpg",
                    "https://1.bp.blogspot.com/_kCsHS-JVeo8/TLPjwDAlgKI/AAAAAAAAA6Q/c6U3LxyYfOY/s1600/rage-against-the-machine.jpg",
                    "https://upload.wikimedia.org/wikipedia/commons/3/3f/Sum_41_logo.jpeg",
                    "https://media.kidozi.com/unsafe/600x600/img.kidozi.com/design/600/600/0a0909/8044/1478277574-Pick-of-Destiny.png.jpg",
                    "https://www.logolynx.com/images/logolynx/b2/b266ccf3363d4d482d2f86c41fd74648.jpeg",
                    "https://i.pinimg.com/originals/0b/d3/99/0bd3992c58ca21e513b0e157f30e3ea1.jpg",
                    "https://i.pinimg.com/originals/8d/6f/cf/8d6fcf483f581e27ed2b90d98fa12576.jpg",
                    "https://cdn11.bigcommerce.com/s-hvyyclhs/images/stencil/1280x1280/products/45850/70133/api5ulw3k__21416.1507897124.jpg?c=2&imbypass=on"]
        
        let labels = ["Your Band", "AC/DC", "Blink 182", "Charlie Brown Jr.", "Dire Straits", "Eagles", "Foo Fighters", "Green Day", "Heart", "Iron Maiden", "Judas Priest", "Kansas", "Linkin Park", "Metallica", "Nirvana", "Oasis", "Pink Floyd", "Queen", "Rage Against the Machine", "Sum 41", "Tenacious D", "U2", "Van Halen", "White Stripes", "ZZ Top"]
        
        stories = [["", "", ""],
                    ["https://ligadoamusica.com.br/wp-content/uploads/2019/02/acdc-novo-album.jpg",
                         "https://studiosol-a.akamaihd.net/uploadfile/letras/fotos/4/b/a/c/4bac12508398d63f131e78d4f01c3924.jpg",
                         "https://consequenceofsound.net/wp-content/uploads/2015/09/kaplan-cos-acdc-feat-e1442384032868.jpg?quality=80&w=807"],
                    ["https://i.pinimg.com/originals/2b/85/a9/2b85a967791cd3c9f96299655aba8161.jpg",
                         "https://lastfm.freetls.fastly.net/i/u/770x0/421c153030c54692a2d246ea87c9d3c4.jpg",
                         "https://lh3.googleusercontent.com/proxy/EmROrN-E70VI705ZL_HffcC_lKkS35Xl0pCR-xj4td6k0-sfzTLoHs7yi5uNTMwGvN6d_YcbdYNpfTBNtIyl_RXTJZ249SWDaUjESkn7yQDdRki7PWwplS8LQCsrtriKK9qSjVr4DOc"],
                    ["https://lh3.googleusercontent.com/proxy/3cFdHN0Db-A4hn6L8I-rXTy2qx5kv8W1QJZ9YTDD_D1AVXyVIoi3NALYsWbypniN0v8KVdz28hJDFgsItqj_dP0cFW6jNaKY66mvYLSGvowA-xOokUS3z3O3cXQzEiM2U025SQ6Qr8Yqq0ZxQKJKFFGHoIxRrehvfz6DZiyNPs9OXm-jZOEu",
                         "https://rollingstone.uol.com.br/media/_versions/legacy/2013/img-1017355-galeria-melhores-musicas-de-champignon-no-charlie-brown-jr-c_widelg.jpg",
                         "https://jpimg.com.br/uploads/2019/01/chior%C3%A3o.png"],
                    ["https://www.dw.com/image/49967064_303.jpg",
                         "https://i.ytimg.com/vi/SMKjIdZ0tlg/hqdefault.jpg",
                         "https://upload.wikimedia.org/wikipedia/commons/a/a2/Dire_straits_22101985_23_800.jpg"],
                    ["https://cdn.britannica.com/50/198850-050-46C563B5/Eagles-Bernie-Leadon-Don-Henley-Glenn-Frey.jpg", "https://s1.dmcdn.net/v/GQ5V21NgqircnzbPH/x1080", "https://i.pinimg.com/originals/a2/a9/e5/a2a9e55fdcc47c969c906739fe786e5f.jpg"],
                    ["https://yoconciertos.com/wp-content/uploads/2019/11/2017_FooFighters3_DannyNorth_121017.jpg", "https://rollingstone.uol.com.br/media/_versions/dia02_palco_mundo_foo_fighters_renan_olivetti_ihf-5598_widelg.jpg", "https://www.foofighterslive.com/news/wp-content/uploads/2018/09/header-image-seattle-750x425.jpg"],
                    ["https://s2.glbimg.com/hQ_rC4zRMSEjVZexRns6t5w2-2E=/1200x/smart/filters:cover():strip_icc()/i.s3.glbimg.com/v1/AUTH_59edd422c0c84a879bd37670ae4f538a/internal_photos/bs/2020/q/B/LDwJqcTr6iBN99GlKRoQ/greenday.jpg", "https://rollingstone.uol.com.br/media/_versions/green_day_em_sao_paulo_1_1_widelg.jpg", "https://www.billboard.com/files/media/green-day-redbull-soundspace-2016-billboard-1548.jpg"],
                    ["https://s3.amazonaws.com/busites_www/heartmusic/1-default/2-heart-music/vfc23rv_1551399329.jpg", "https://media.gettyimages.com/photos/nancy-wilson-of-the-band-heart-performs-at-acl-live-on-november-16-picture-id525387668?s=612x612", "https://townsquare.media/site/295/files/2013/03/73993075.jpg?w=600&h=0&zc=1&s=0&a=t&q=89"],
                    ["https://townsquare.media/site/366/files/2018/10/Iron-Maiden.jpg?w=980&q=75", "https://www.myfreewallpapers.net/music/wallpapers/rock-in-rio-iron-maiden.jpg", "https://ewscripps.brightspotcdn.com/dims4/default/647209d/2147483647/strip/true/crop/1024x576+0+54/resize/1280x720!/quality/90/?url=https%3A%2F%2Fewscripps.brightspotcdn.com%2F82%2F7a%2Fd3af902c4b68a736d0afc19e8c3d%2Firon-maiden-getty-053019.jpg"],
                    ["https://s2.glbimg.com/Fgtl3W90_YqxI4RZ3wzO4qwupmE=/top/i.glbimg.com/og/ig/infoglobo1/f/original/2018/02/28/judas-priest-2018.jpg", "https://acl-live.com/wp-content/uploads/2019/04/Judas-Priest-Blank-1024x1024.jpg", "https://lh3.googleusercontent.com/proxy/2WnbgOtt2ePJwsn9Ie9bcpQTwB3-qChJcbchpEdGbPTWaren0HK9mn6B4OYdsrXIp0DuFc8DOyR_VnmdAUnNw6hyMCh7gj2VGw"],
                    ["https://www.post-gazette.com/image/2013/10/17/1140x_a10-7_cTC/1970s-Kansas.jpg", "https://i.ytimg.com/vi/IJfUDMyAb2c/maxresdefault.jpg", "https://cdn.mos.cms.futurecdn.net/TBmpi8BzxfnZUPsianTAuc.jpg"],
                    ["https://www12.senado.leg.br/radio/1/capitulo-rock/linkin-park/likin.jpg/@@images/aff7c9e1-d759-4a8c-ac4f-eacc3a8dcb75.jpeg", "https://www.jornalnopalco.com.br/wp-content/uploads/2017/07/01-linkin-park-2017-cr-James-Minchin-billboard-1548.jpg", "https://www.acritica.com/uploads/news/image/735415/show_nintchdbpict000135444347.jpg"],
                    ["https://i.pinimg.com/originals/c7/61/2b/c7612bf5fc359b2227259d8a7bd232f0.jpg", "https://ligadoamusica.com.br/wp-content/uploads/2017/05/metallica-live-in-singapore.jpg", "https://i.ytimg.com/vi/0d-uI6DdL_w/maxresdefault.jpg"],
                        ["https://www.rockbizz.com.br/wp-content/uploads/2016/04/Nirvana.jpg", "https://www.liveabout.com/thmb/QeM1HpQW94OIOoY4XlBYOj6Yzw4=/768x0/filters:no_upscale():max_bytes(150000):strip_icc()/3299416686_8f75caec59_o-5a4aeee0ec2f6400375407e3.jpg", "https://www.billboard.com/files/styles/article_main_image/public/media/kurt-cobain-nirvana-live-and-loud-mtv-1993-billboard-1548.jpg"],
                        ["https://ichef.bbci.co.uk/images/ic/960x540/p02tvx05.jpg", "https://www.nme.com/wp-content/uploads/2016/09/2015Oasis_2009_GettyImages-95638728160715-1.jpg", "https://www.nme.com/wp-content/uploads/2016/09/2015CallingFestival_NoelGallagher_GettyImages-479475598_master060715-1-696x464.jpg"],
                        ["https://upload.wikimedia.org/wikipedia/commons/4/4d/Pink_Floyd%2C_1971.jpg", "https://i.ytimg.com/vi/HX_du6Gcp1w/maxresdefault.jpg", "https://ichef.bbci.co.uk/images/ic/640x360/p037v6m8.jpg"],
                        ["https://imagens.brasil.elpais.com/resizer/gxERwIglloyWgnJa48qt7hSEBPY=/768x0/ep01.epimg.net/elpais/imagenes/2018/11/08/icon/1541671935_509035_1541708505_noticia_fotograma.jpg", "https://images.impresa.pt/blitz/2019-05-07-QueenLiveAid.jpg/original/mw-860", "https://images.metadata.sky.com/pd-image/4083d335-275e-4891-b24f-8dfab7cbf2de/16-9"],
                        ["https://media.pitchfork.com/photos/5e41b91aa42e4e000882e48b/2:1/w_790/Rage-Against-the-Machine.jpg", "https://www.vagalume.com.br/dynimage/news39241-big.jpg", "https://lh3.googleusercontent.com/proxy/crGfGJzcHVA0xgHh2B8UbwfArn97KQDdCOH6GUqbHYO0dSpl-pmNIBJmPL9Mae-4oQnQaOc6Xpe3wbgYQQWy9WFdEzP36RyKGY1hQI4OOnStgzeMCq1VuDXDyULjmTF47O_HkdM_hT6cBkfeVZ7XEvKq89ezR6pXgTUl9j7nSceHusJKivwX1Bs"],
                        ["https://studiosol-a.akamaihd.net/uploadfile/letras/fotos/6/d/7/2/6d72b8ce58480efd31fabc82f7b813e6.jpg", "https://upload.wikimedia.org/wikipedia/commons/9/90/2017_RiP_-_Sum_41_-_Dave_Baksh_-_by_2eight_-_8SC8087.jpg", "https://images.squarespace-cdn.com/content/v1/577e9f3a9f74569483cffe78/1561721879257-VAQ3CYR5QIUOMEMZODG4/ke17ZwdGBToddI8pDm48kFfuzEoTUmMOHAiO22plwdZ7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z5QPOohDIaIeljMHgDF5CVlOqpeNLcJ80NK65_fV7S1Ud6QDxNo9Q5qGFSEZXZiD18hmp85zib2cPuleJvlYu25EScPl68-HedYwuxfQyDbKQ/sum41-5.jpg"],
                        ["https://s.yimg.com/ny/api/res/1.2/ivazRr_sRUglgDKnxF6pJg--~A/YXBwaWQ9aGlnaGxhbmRlcjtzbT0xO3c9ODAw/https://media.zenfs.com/en-US/rollingstone.com/6fb9869b128910027a2f6937e676858a", "https://media.spokesman.com/photos/2016/11/30/AP_676987747521_sc1fhUp.jpg", "https://www.nme.com/wp-content/uploads/2016/09/2010TenaciousD02PA060212.jpg"],
                        ["https://vignette.wikia.nocookie.net/ydgmusic/images/d/d2/U2Photo.png/revision/latest?cb=20171009021125", "https://res.cloudinary.com/culturemap-com/image/upload/ar_4:3,c_fill,g_faces:center,w_1200/v1483970859/photos/145920_original.jpg", "https://citacoes.in/media/authors/22411_bono.jpeg"],
                        ["https://roadiecrew.com/wp-content/uploads/van-halen-700x405.jpg", "https://cdn.shopify.com/s/files/1/0956/6826/products/mw059a.jpeg?v=1439517489", "https://ligadoamusica.com.br/wp-content/uploads/2019/10/eddie_van_halen.jpg"],
                        ["https://rollingstone.uol.com.br/media/_versions/white_stripes_-_tim_roney_getty_images_widelg.jpg", "https://i.ytimg.com/vi/ZpEtBoKvE2Y/maxresdefault.jpg", "https://maubrecht.files.wordpress.com/2015/10/meg_white.jpg?w=584"],["https://3apq7g38q3kw2yn3fx4bojii-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/471207836_zz-top.jpg","https://1.bp.blogspot.com/-g_h2Y-BoZqM/XXUX2676RCI/AAAAAAAAUbQ/Rnq3-bEOd_MBoRDtInTHmdj-o-Us0tDQwCLcBGAs/s1600/zz%2Btop.jpg", "https://www.rockbizz.com.br/wp-content/uploads/2018/07/billy-gibbons-zz-top.jpg"]]
        
        var collectionData: [StoriesCollectionData] = []
        
        for (index, url) in urls.enumerated() {
            collectionData.append(StoriesCollectionData(imageUrl: url, label: labels[index]))
        }
       
        let storiesData = StoriesData(collectionData: collectionData)
        storiesContainerView.configure(data: storiesData, delegate: self)
    }
}

// MARK: StoriesCollectionView
extension ExampleViewController: StoriesCollectionViewDelegate {
    func didSelectCell(index: Int, frame: CGRect) {
        let viewController = StoriesViewController(transitioningDelegate: self, stories: stories[index])
        storiesDelegate = viewController
        transitioningViewFrame = frame
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true, completion: {
            self.storiesDelegate?.didFinishOpeningStories()
        })
    }
}

// MARK: Transitioning Delegate
extension ExampleViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.viewColor = UIColor(red: 19/255, green: 19/255, blue: 19/255, alpha: 1)
        transition.triggeringFrame = transitioningViewFrame
        return transition
    }
}
