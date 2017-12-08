import { ChangeDetectorRef, Component, OnChanges, OnInit, ViewChild } from '@angular/core';
import { User } from '../../models/user.model';
import { Event, document } from 'angular-bootstrap-md/utils/facade/browser';
import { Router, ActivatedRoute } from '@angular/router';

//services
import { UserService } from '../../services/user/user.service';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.scss']
})
export class ProfileComponent implements OnInit {
  @ViewChild('fileInput') fileInput;
  currentUser: User;
  isEdit: boolean;
  myBio: String;
  showFollowers: boolean;
  showRatedMovies: boolean;
  showWatchlistMovies: boolean;
  showRecommendedMovies: boolean;
  currentScreen:number;
  isLoggedInUser: boolean;
  isFollowed: boolean;
  fullName: string;

  loggedUser: User;

  constructor(private router:Router, 
              private route: ActivatedRoute, 
              private userService: UserService,
              private cdRef: ChangeDetectorRef) {
      this.currentUser = JSON.parse(localStorage.getItem('currentUser'));    
      // // console.log(this.currentUser); 
      // this.currentUser.Email=["khaledawaled@live.com"];
      // this.currentUser.Age = 21;
      // this.currentUser.bio = "";
      //localStorage.setItem('currentUser',JSON.stringify(this.currentUser));
      this.currentScreen = 0;
      this.isEdit = false;
      this.showFollowers = false;
      this.showRatedMovies = true;
      this.showWatchlistMovies = false;
      this.showRecommendedMovies = false;
      this.currentUser.Friends=[]
     // this.currentUser.Friends.push(this.currentUser);
       localStorage.setItem('currentUser',JSON.stringify(this.currentUser));
      // console.log(this.currentUser.Friends);
  }

  ngOnInit() {
    // console.log(this.cdRef.detectChanges())
    const id = +this.route.snapshot.paramMap.get('id');
    console.log(id)
    console.log(this.route.snapshot.data)
    if(this.route.snapshot.data['user'] === null)
      this.router.navigate(['/404']);
    this.isLoggedInUser = (this.currentUser.UserID === this.route.snapshot.data['user'].UserID) ? true : false;
    if(!this.isLoggedInUser){
      let ok: boolean = false;
      this.currentUser.Following = this.currentUser.Following || [];
      this.currentUser.Following.forEach(usr =>{
        if(usr.UserID === id){
          ok = true;
        }
      })
      this.isFollowed = ok;
    }
    // // console.log(this.isLoggedInUser)
    this.currentUser = this.route.snapshot.data['user'];

    this.fullName = this.currentUser.FirstName + ' ' + this.currentUser.LastName;
    this.currentUser.bio = "ana esmy hamada"

    this.loggedUser = JSON.parse(localStorage.getItem('currentUser'))
    // console.log(this.currentUser)
  }
  takeAction(element){
    this.isEdit = !this.isEdit;
    if(this.isEdit){
       element.textContent = "SAVE";
    }
    else{
      localStorage.setItem('currentUser',JSON.stringify(this.currentUser)); 
      this.updateUsersList(this.currentUser);      
      element.textContent = "EDIT PROFILE";
    }
  }
  chooseScreen(e)
  {
    this.currentScreen = e ; 
    console.log(e)
  }
  onFileChange(fileInput: any){
    this.currentUser.profilePic = fileInput.target.files[0];
    let reader = new FileReader();

    reader.onload = (e: any) => {
        this.currentUser.profilePic = e.target.result;
        localStorage.setItem('currentUser',JSON.stringify(this.currentUser));
        console.log('tamam?')
        this.updateUsersList(this.currentUser);           
    }
    reader.readAsDataURL(fileInput.target.files[0]);
  } 
  updateUsersList(user: User) {
    const users: User[] = JSON.parse(localStorage.getItem('users'));
    const index: number = users
      .findIndex(item => item.UserID === user.UserID);
    users[index] = user;
    console.log('tamam')
    localStorage.setItem('users', JSON.stringify(users));
  }

  chooseTab(id: number){
    console.log(id)
    if(id == 1){
      this.showRatedMovies = true;
      this.showFollowers = false;
      this.showWatchlistMovies = false;
      this.showRecommendedMovies = false;
    }
    else if(id == 2){
      this.showRatedMovies = false;
      this.showFollowers = false;
      this.showWatchlistMovies = true;
      this.showRecommendedMovies = false;
    }
    else if(id == 4){
      this.showRatedMovies = false;
      this.showFollowers = true;
      this.showWatchlistMovies = false;
      this.showRecommendedMovies = false;
    }
    else if(id == 5){
      this.showRatedMovies = false;
      this.showFollowers = false;
      this.showWatchlistMovies = false;
      this.showRecommendedMovies = true;
      console.log(id)
    }
  }

  hh(){
    console.log('hamada')
  }

  follow(){
    let usr: User = JSON.parse(localStorage.getItem('currentUser'));  
    usr.Following = usr.Following || [] 
    usr.Following.push(this.currentUser);
    localStorage.setItem('currentUser', JSON.stringify(usr));
    this.updateUsersList(usr);
    this.isFollowed = !this.isFollowed;
    console.log(this.isFollowed)
  }

  unfollow(){
    let usr: User = JSON.parse(localStorage.getItem('currentUser')); 
    usr.Following = usr.Following || []     
    const index: number = usr.Following.findIndex(item => item.UserID === this.currentUser.UserID);
    usr.Following.splice(index, 1);
    localStorage.setItem('currentUser', JSON.stringify(usr));
    this.updateUsersList(usr);
    this.isFollowed = !this.isFollowed;    
  }
}
